MODULE Module1

   PERS tooldata rGripper := [ TRUE, [ [0, 0, 0], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];
   PERS tooldata rSucker := [ TRUE, [ [68, 55, 45], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];
   PERS tooldata currentTool;

   VAR robtarget vial_1:=[[382.26,-289,123.83],[0.482297,-0.5219,0.501286,-0.493683],[1,1,1,4],[177.511,9E+09,9E+09,9E+09,9E+09,9E+09]];
   VAR robtarget vial_hold_closed:=[[358.75,124.59,399.17],[0.482274,-0.521953,0.50126,-0.493675],[1,2,0,4],[177.512,9E+09,9E+09,9E+09,9E+09,9E+09]];
   VAR robtarget vial_hold_open:=[[358.74,124.57,348.23],[0.48226,-0.521963,0.501263,-0.493674],[1,2,0,4],[177.508,9E+09,9E+09,9E+09,9E+09,9E+09]];
   VAR robtarget vial_on_pad_upright:=[[205.48,-133.44,153.70],[0.482241,-0.52197,0.501278,-0.493671],[1,1,0,4],[177.511,9E+09,9E+09,9E+09,9E+09,9E+09]];
   VAR robtarget vial_on_pad_inverted:=[[205.48,-133.45,153.62],[0.490126,0.50509,0.518289,0.485836],[1,1,-2,4],[177.511,9E+09,9E+09,9E+09,9E+09,9E+09]];
   VAR robtarget CO2_pad_origin:=[[182.09,-191.13,184.02],[0.50416,-0.531641,0.497275,-0.464648],[1,1,0,4],[-176.821,9E+09,9E+09,9E+09,9E+09,9E+09]];
   VAR string targets{6} := ["vial_1", "vial_hold_closed", "vial_hold_open", "vial_on_pad_upright", "vial_on_pad_inverted", "CO2_pad_origin"];
   VAR robtarget currentTarget;
   VAR socketdev serverSocket;
   VAR socketdev clientSocket;
   VAR string data;
   PERS string state := "unexecuted";
   PERS string dat := "L_MOVE_L_1_1_";
   VAR string data_to_send;

   PERS string robot;
   PERS string action;
   PERS string action_type;
   PERS string tool_index := "1";
   PERS string target;
   PERS string target_index := "1";
   VAR bool ok;
   PERS num index_tool := 1;
   PERS num index_target := 1 ;
   VAR num posLastUnderscore;
   VAR num posHash1;
   VAR num posHash2;
   PERS num offX;
   PERS num offY;
   PERS num offZ;

   VAR num testNum := 0;
   VAR string testString := "-2.0";






    PROC main()

        g_Init;
        ok := StrToVal(testString,testNum);
        TPWrite " "\Num:=testNum;


        IF state = "Lexecuted" and SocketGetStatus(serverSocket)<>SOCKET_CLOSED THEN
            state := "executed";
            SocketSend clientSocket \Str:=state;
            SocketClose clientSocket;
            SocketClose serverSocket;
        ENDIF

        IF SocketGetStatus(serverSocket) = SOCKET_CLOSED THEN
         SocketClose serverSocket;
         SocketCreate serverSocket;
         SocketBind serverSocket,"192.168.125.1",4646;
         SocketListen serverSocket;
         SocketAccept serverSocket,clientSocket,\Time:=WAIT_MAX;
         SocketReceive clientSocket \Str:=data;
         state := "unexecuted";
         dat := data;
         IF StrFind(dat,1,"_") < StrLen(dat) THEN
              robot := StrPart(dat,1,1);
              action := StrPart(dat,3,4);
              action_type := StrPart(dat,8,1);

              tool_index := StrPart(dat,10,1);
              ok:= StrToVal(tool_index,index_tool);

              ok:=StrToVal(StrFind(dat,12,"_"),posLastUnderscore);
              ok:=StrToVal(StrFind(dat,posLastUnderscore+1,"#"),posHash1);
              ok:=StrToVal(StrFind(dat,posHash1+1,"#"),posHash2);

              target_index := StrPart(dat,12,posLastUnderscore-12);
              ok := StrToVal(target_index,index_target);

              ok := StrToVal(StrPart(dat,posLastUnderscore+1,posHash1-posLastUnderscore-1),offX)
              ok := StrToVal(StrPart(dat,posHash1+1,posHash2-posHash1-1),offY)
              ok := StrToVal(StrPart(dat,posHash2+1,StrLen(dat)-posHash2),offZ)

         ENDIF
       ENDIF

       IF state = "unexecuted" THEN
            IF dat = "Rgrip" THEN
                g_GripIn;
                WaitRob\InPos;
                state := "executed";
                SocketSend clientSocket \Str:=state;
                SocketClose clientSocket;
                SocketClose serverSocket;
            ENDIF
            IF dat = "Rleave" THEN
                g_GripOut;
                WaitRob\InPos;
                state := "executed";
                SocketSend clientSocket \Str:=state;
                SocketClose clientSocket;
                SocketClose serverSocket;
            ENDIF
            IF dat = "RgripVialFromHolder" THEN
                RgripVialFromHolder;
                state := "executed";
                SocketSend clientSocket \Str:=state;
                SocketClose clientSocket;
                SocketClose serverSocket;
            ENDIF
             IF dat = "RplaceVialInHolder" THEN
               RplaceVialInHolder;
                state := "executed";
                SocketSend clientSocket \Str:=state;
                SocketClose clientSocket;
                SocketClose serverSocket;
            ENDIF
            IF robot="R" THEN
                TEST index_tool
                CASE 1: currentTool := rGripper;
                CASE 2: currentTool := rSucker;
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

                state := "executed";
                robot := "";
                action := "";
                action_type := "";
                target := "";
                SocketSend clientSocket \Str:=state;
                SocketClose clientSocket;
                SocketClose serverSocket;
            ENDIF
       ENDIF
       ERROR
          IF ERRNO = ERR_SOCK_TIMEOUT THEN
                  RETRY;
          ENDIF
    ENDPROC
    PROC RgripVialFromHolder()
        g_GripOut;
        WaitRob\InPos;
        MoveL Offs(CRobT(),53,0,0),v100,z10,rGripper;
        WaitRob\InPos;
        g_GripIn;
        MoveL Offs(CRobT(),0,0,50),v100,z10,rGripper;
        WaitRob\InPos;
    ENDPROC
    PROC RplaceVialInHolder()
        MoveL Offs(CRobT(),0,0,50),v100,z10,rGripper;
        WaitRob\InPos;
        MoveL Offs(CRobT(),52,0,0),v100,z10,rGripper;
        WaitRob\InPos;
        MoveL Offs(CRobT(),0,0,-50),v100,z10,rGripper;
        WaitRob\InPos;
        g_GripOut;
        WaitRob\InPos;
        MoveL Offs(CRobT(),0,0,50),v100,z10,rGripper;
        WaitRob\InPos;
        MoveL Offs(CRobT(),-52,0,0),v100,z10,rGripper;
        WaitRob\InPos;
        MoveL Offs(CRobT(),0,0,-50),v100,z10,rGripper;
        WaitRob\InPos;
    ENDPROC
ENDMODULE
