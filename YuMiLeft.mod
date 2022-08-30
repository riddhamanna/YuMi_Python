MODULE Module1

    PERS tooldata lGripper := [ TRUE, [ [0, 0, 0], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];
    PERS tooldata lSucker := [ TRUE, [ [42, 12, 38], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];
    PERS tooldata currentTool;

    VAR robtarget bridge_lcd_CO2:=[[469.60,126.75,541.36],[0.00234211,0.0279703,0.999606,0.000966869],[0,0,0,4],[-120.431,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget plate_on_CO2:=[[473.91,125.93,221.19],[0.0134908,0.00500809,-0.999896,0.00127611],[-1,1,-1,4],[-120.192,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget plate_on_lcd_1:=[[416.00,395.46,294.03],[0.011255,0.718489,0.694978,0.0255325],[-1,1,1,4],[125.838,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget plate_on_lcd_2:=[[413.89,560.05,294.38],[0.0286882,0.714294,0.69858,0.0307649],[-1,1,1,4],[133.482,9E+09,9E+09,9E+09,9E+09,9E+09]];

    VAR string targets{4} := ["bridge_lcd_CO2", "plate_on_lcd_1", "plate_on_lcd_2", "plate_on_CO2" ];
    VAR robtarget currentTarget;

    VAR robtarget testPos:=[[438.31,-18.16,327.27],[0.00310321,0.00173247,-0.999969,-0.0069552],[0,1,-1,4],[-128.234,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget testTarget;

    PERS string dat := "L_MOVE_L_1_1_";
    PERS string state := "unexecuted";

    PERS string robot;
    PERS string action;
    PERS string action_type;
    PERS string tool_index;
    PERS string target_index;
    VAR bool ok;
    PERS num index_tool;
    PERS num index_target;
    PERS num offX;
    PERS num offY;
    PERS num offZ;





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
            IF dat = "testPos" THEN
                GetDataVal dat, testTarget;
                MoveJ testTarget,v100,z10,lGripper;
                state := "Lexecuted";
            ENDIF
            IF robot="L" THEN

                TEST index_tool
                CASE 1: currentTool := lGripper;
                CASE 2: currentTool := lSucker;
                ENDTEST
                IF index_target = 0 THEN
                    currentTarget := CRobT();
                ELSE
                    GetDataVal targets{index_target}, currentTarget;
                ENDIF
                IF ACTION = "MOVE" THEN
                    IF action_type = "L" THEN
                        MoveL currentTarget,v100,z10,currentTool;
                        WaitRob\InPos;
                    ENDIF
                    IF action_type = "J" THEN
                        MoveJ currentTarget,v100,z10,currentTool;
                        WaitRob\InPos;
                    ENDIF
                ENDIF
                IF ACTION = "OFFS" THEN
                    IF action_type = "L" THEN
                        MoveL Offs(currentTarget,offX,offY,offZ),v100,z10,currentTool;
                        WaitRob\InPos;
                    ENDIF
                    IF action_type = "J" THEN
                        MoveJ Offs(currentTarget,offX,offY,offZ),v100,z10,currentTool;
                        WaitRob\InPos;
                    ENDIF
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
        MoveL Offs(CRobT(),0,0,-40),v100,z10,lGripper;
        WaitRob\InPos;
        g_GripIn;
        MoveL Offs(CRobT(),0,0,40),v100,z10,lGripper;
        WaitRob\InPos;
    ENDPROC
     PROC LdropPlateOnLCD()
        !g_GripIn;
        WaitRob\InPos;
        MoveL Offs(CRobT(),0,0,-41),v100,z10,lGripper;
        WaitRob\InPos;
        g_GripOut;
        MoveL Offs(CRobT(),0,0,41),v100,z10,lGripper;
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
