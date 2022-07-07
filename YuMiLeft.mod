MODULE Module1

    PERS tooldata lGripper := [ TRUE, [ [0, 0, 0], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];
    PERS tooldata lSucker := [ TRUE, [ [42, 12, 38], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];
    PERS tooldata currentTool;

    CONST robtarget plate_on_lcd_1:=[[409.84,457.95,403.65],[0.00212622,-0.674497,-0.738239,-0.00725704],[0,0,1,4],[-119.526,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget bridge_lcd_CO2:=[[469.60,126.75,541.36],[0.00234211,0.0279703,0.999606,0.000966869],[0,0,0,4],[-120.431,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget plate_on_CO2:=[[473.91,125.93,221.19],[0.0134908,0.00500809,-0.999896,0.00127611],[-1,1,-1,4],[-120.192,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget targets{3} := [plate_on_lcd_1, bridge_lcd_CO2, plate_on_CO2 ];

    PERS string dat := "L_MOVE_L_1_2";
    PERS string state := "executed";

    PERS string robot;
    PERS string action;
    PERS string action_type;
    PERS string tool_index;
    PERS string target_index;
    VAR bool ok;
    PERS num index_tool;
    PERS num index_target;


    PROC main()

        g_Init;

        IF state = "unexecuted" THEN
            IF dat = "Lgrip" THEN
                g_GripIn;
                WaitRob\InPos;
                state := "Lexecuted";
            ENDIF
            IF dat = "Lleave" THEN
                g_GripOut;
                WaitRob\InPos;
                state := "Lexecuted";
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

                TEST index_tool
                CASE 1: currentTool := lGripper;
                CASE 2: currentTool := lSucker;
                ENDTEST
                IF action_type = "L" THEN
                    MoveL targets{index_target},v100,z10,currentTool;
                    WaitRob\InPos;
                ENDIF
                IF action_type = "J" THEN
                    MoveJ targets{index_target},v100,z10,currentTool;
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
