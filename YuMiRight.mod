MODULE Module1

   PERS tooldata rGripper := [ TRUE, [ [0, 0, 0], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];
   PERS tooldata rSucker := [ TRUE, [ [68, 55, 45], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];
   PERS tooldata currentTool;

   CONST robtarget vial_1:=[[382.26,-286.35,123.83],[0.482297,-0.5219,0.501286,-0.493683],[1,1,1,4],[177.511,9E+09,9E+09,9E+09,9E+09,9E+09]];
   CONST robtarget vial_hold_closed:=[[358.75,124.59,399.17],[0.482274,-0.521953,0.50126,-0.493675],[1,2,0,4],[177.512,9E+09,9E+09,9E+09,9E+09,9E+09]];
   VAR robtarget targets{2} := [vial_1, vial_hold_closed];

   VAR socketdev serverSocket;
   VAR socketdev clientSocket;
   VAR string data;
   PERS string state := "executed";
   PERS string dat := "L_MOVE_L_1_2";
   VAR string data_to_send;

   PERS string robot;
   PERS string action;
   PERS string action_type;
   PERS string tool_index := "";
   PERS string target;
   PERS string target_index := "";
   VAR bool ok;
   PERS num index_tool := 1;
   PERS num index_target := 2 ;


    PROC main()

        g_Init;

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
              target_index := StrPart(dat,12,StrLen(dat)-11);
              ok := StrToVal(target_index,index_target);
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
            IF robot="R" THEN
                TEST index_tool
                CASE 1: currentTool := rGripper;
                CASE 2: currentTool := rSucker;
                ENDTEST
                IF action_type = "L" THEN
                    MoveL targets{index_target},v100,z10,currentTool;
                    WaitRob\InPos;
                ENDIF
                IF action_type = "J" THEN
                    MoveJ targets{index_target},v100,z10,currentTool;
                    WaitRob\InPos;
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
ENDMODULE
