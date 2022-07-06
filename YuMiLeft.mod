MODULE Module1

    !CONST num dist_btwn_maze := 30;
    !CONST num offSet_x :=20;
    !CONST num offSet_y := 25;

    !CONST pose userFrame := [[220,-600,60],[1,0,0,0]];
    !CONST pose gridPos_usF := [[50,300,12],[1,0,0,0]];
    !CONST pose arenaPos_usF := [[50,700,0],[1,0,0,0]];

    !PERS num gridX;
    !PERS num gridY;
    !PERS num arenaNum;
    !PERS num arenaX;
    !PERS num arenaY;

    !PERS wobjdata arena;
    !PERS wobjdata grid;

    !CONST robtarget arenaOrigin:=[[0,0,10],[0.5,0.5,0.5,-0.5],[0,0,0,4],[-180,9E+09,9E+09,9E+09,9E+09,9E+09]];

    !PERS tasks tasklist{2} := [["T_ROB_R"],["T_ROB_L"]];
    !VAR syncident sync1;
    !VAR syncident sync2;

    !PERS bool sync := TRUE;
    !TASK PERS tooldata tcp_spike:=[TRUE,[[-0.224885,-0.320784,192.077],[1,0,0,0]],[0.2,[0,0,20],[1,0,0,0],0,0,0]];
    !TASK PERS wobjdata Maze_PL2:=[FALSE,TRUE,"",[[598.844,162.541,61.0026],[0.00428631,-0.00112024,0.000720537,-0.99999]],[[0,0,0],[1,0,0,0]]];
    !TASK PERS wobjdata CO2_Pad:=[FALSE,TRUE,"",[[455.329,54.6497,54.7239],[0.000597976,0.00273497,0.00237769,0.999993]],[[0,0,0],[1,0,0,0]]];
    !CONST robtarget testL:=[[127.59,33.60,-56.34],[0.0132209,-0.0222916,-0.999656,0.00407234],[1,1,1,0],[-139.469,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !CONST robtarget testL1:=[[467.60,119.20,227.50],[0.00461796,-0.999751,0.0180597,-0.0122511],[1,1,1,0],[-125.664,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !CONST robtarget testL2:=[[467.60,-118.65,227.50],[0.00462144,-0.999751,0.0180568,-0.0122352],[0,1,1,0],[-125.663,9E+09,9E+09,9E+09,9E+09,9E+09]];


    CONST tooldata lGripper := [ TRUE, [ [0, 0, 0], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];
    CONST tooldata lSucker := [ TRUE, [ [42, 12, 38], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];

    VAR tooldata tools{2} := [lGripper, lSucker];

    PERS string dat := "leave";
    PERS string state := "executed";

    PERS string robot;
    PERS string action;
    PERS string action_type;
    PERS string tool_index;
    PERS string target_index;


    VAR bool ok;
    VAR num index_tool;
    VAR num index_target;


    CONST robtarget plate_on_lcd_1:=[[409.84,457.95,403.65],[0.00212622,-0.674497,-0.738239,-0.00725704],[0,0,1,4],[-119.526,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget bridge_lcd_CO2:=[[469.60,126.75,541.36],[0.00234211,0.0279703,0.999606,0.000966869],[0,0,0,4],[-120.431,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget plate_on_CO2:=[[473.91,125.93,221.19],[0.0134908,0.00500809,-0.999896,0.00127611],[-1,1,-1,4],[-120.192,9E+09,9E+09,9E+09,9E+09,9E+09]];

    VAR robtarget targets{3} := [plate_on_lcd_1, bridge_lcd_CO2, plate_on_CO2 ];


    PROC main()

        g_Init;
        !sync := TRUE;
        !arena.robhold := FALSE;
        !arena.ufprog := TRUE;
        !arena.ufmec := "";
        !arena.uframe := userFrame;
        !arena.oframe := arenaPos_usF;

        !grid.robhold := FALSE;
        !grid.ufprog := TRUE;
        !grid.ufmec := "";
        !grid.uframe := userFrame;
        !grid.oframe := gridPos_usF;

        IF state = "unexecuted" THEN
            IF dat = "Lgrip" THEN
                g_GripIn;
                WaitRob\InPos;
            ENDIF
            IF dat = "Lleave" THEN
                g_GripOut;
                WaitRob\InPos;
            ENDIF
            IF dat = "LgripPlateFromLCD" THEN
                LgripPlateFromLCD;
                state := "Lexecuted";
            ENDIF
             IF dat = "LdropPlateOnLCD" THEN
                LdropPlateOnLCD;
                state := "Lexecuted";
            ENDIF
             IF dat = "LgripPlateFromCO2" THEN
                LgripPlateFromCO2;
                state := "Lexecuted";
            ENDIF
             IF dat = "LdropPlateOnCO2" THEN
                LdropPlateOnCO2;
                state := "Lexecuted";
            ENDIF
            IF robot="L" THEN
                IF action_type = "L" THEN
                    MoveL targets{index_target},v100,z10,tools{index_tool};
                    WaitRob\InPos;
                ENDIF
                IF action_type = "J" THEN
                    MoveJ targets{index_target},v100,z10,tools{index_tool};
                    WaitRob\InPos;
                ENDIF

                state := "Lexecuted";
                robot := "";
                action := "";
                action_type := "";
                tool_index := "";
                target_index := "";
            ENDIF
        ENDIF
    ENDPROC
     PROC LgripPlateFromLCD()
        g_GripOut;
        WaitRob\InPos;
        MoveL Offs(CRobT(),0,0,-43),v100,z10,lGripper;
        WaitRob\InPos;
        g_GripIn;
        MoveL Offs(CRobT(),0,0,43),v100,z10,lGripper;
        WaitRob\InPos;
    ENDPROC
     PROC LdropPlateOnLCD()
        !g_GripIn;
        WaitRob\InPos;
        MoveL Offs(CRobT(),0,0,-43),v100,z10,lGripper;
        WaitRob\InPos;
        g_GripOut;
        MoveL Offs(CRobT(),0,0,43),v100,z10,lGripper;
        WaitRob\InPos;
    ENDPROC
    PROC LgripPlateFromCO2()
        g_GripOut;
        WaitRob\InPos;
        MoveL Offs(CRobT(),0,0,-25),v100,z10,lGripper;
        WaitRob\InPos;
        g_GripIn;
        MoveL Offs(CRobT(),0,0,25),v100,z10,lGripper;
        WaitRob\InPos;
    ENDPROC
     PROC LdropPlateOnCO2()
        !g_GripIn;
        WaitRob\InPos;
        MoveL Offs(CRobT(),0,0,-25),v100,z10,lGripper;
        WaitRob\InPos;
        g_GripOut;
        MoveL Offs(CRobT(),0,0,25),v100,z10,lGripper;
        WaitRob\InPos;
    ENDPROC
ENDMODULE
