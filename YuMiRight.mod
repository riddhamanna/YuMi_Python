MODULE Module1

   !CONST num dist_btwn_maze := 30;
   !CONST num offSet_x := 35;
   !CONST num offSet_y := 20;

   !CONST pose userFrame := [[220,-600,60],[1,0,0,0]];
   !CONST pose gridPos_usF := [[50,300,12],[1,0,0,0]];
   !CONST pose arenaPos_usF := [[50,700,0],[1,0,0,0]];

   !PERS wobjdata grid;
   !PERS wobjdata arena;

   !CONST robtarget gridOrigin:=[[0,0,10],[0.5,-0.5,0.5,-0.5],[0,0,0,4],[-108,9E+09,9E+09,9E+09,9E+09,9E+09]];
   !CONST robtarget arenaOrigin:=[[0,0,10],[0.5,-0.5,0.5,-0.5],[0,0,0,4],[-108,9E+09,9E+09,9E+09,9E+09,9E+09]];

   PERS tooldata rGripper := [ TRUE, [ [0, 0, 0], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];
   PERS tooldata rSucker := [ TRUE, [ [68, 55, 45], [1, 0, 0 ,0] ], [0.262, [7.8, 11.9, 50.7], [1, 0, 0, 0], 0.00022, 0.00024, 0.00009] ];

   !VAR tooldata tools{2} := [rGripper, rSucker];

   VAR socketdev serverSocket;
   VAR socketdev clientSocket;



   VAR string data;
   PERS string state := "executed";
   PERS string dat := "L_MOVE_L_1_2";

   PERS string robot;
   PERS string action;
   PERS string action_type;
   PERS string tool_index := "";
   PERS string target;
   PERS string target_index := "";

   VAR string data_to_send;
   CONST robtarget vial_1:=[[382.26,-286.35,123.83],[0.482297,-0.5219,0.501286,-0.493683],[1,1,1,4],[177.511,9E+09,9E+09,9E+09,9E+09,9E+09]];
   CONST robtarget vial_hold_closed:=[[358.75,124.59,399.17],[0.482274,-0.521953,0.50126,-0.493675],[1,2,0,4],[177.512,9E+09,9E+09,9E+09,9E+09,9E+09]];

   VAR robtarget targets{2} := [vial_1, vial_hold_closed];

   VAR bool ok;
   PERS num index_tool := 1;
   PERS num index_target := 2 ;

   !VAR num poshash;
   !VAR num posat;
   !PERS num arenaNum;
   !VAR bool ok;
   !PERS num gridX;
   !PERS num gridY;
   !PERS num arenaX;
   !PERS num arenaY;
   !VAR num len;
   !VAR robtarget rt;
   !VAR string rt_string;

   !PERS tasks tasklist{2} := [["T_ROB_R"],["T_ROB_L"]];
   !VAR syncident sync1;
   !VAR syncident sync2;

   !PERS bool sync := TRUE;
   !TASK PERS tooldata tcp_spike:=[TRUE,[[-0.587089,1.29768,190.43],[1,0,0,0]],[0.2,[0,0,20],[1,0,0,0],0,0,0]];
   !TASK PERS wobjdata Maze_PL1:=[FALSE,TRUE,"",[[616.645,-158.776,61.0989],[0.00554552,-0.000211928,0.00183309,-0.999983]],[[0,0,0],[1,0,0,0]]];
   !TASK PERS wobjdata CO2_Pad:=[FALSE,TRUE,"",[[454.363,55.1985,53.8493],[0.000491398,0.0041039,0.00602228,0.999973]],[[0,0,0],[1,0,0,0]]];
   !TASK PERS wobjdata Needle:=[FALSE,TRUE,"",[[462.436,-340.71,71.7377],[0.0140365,0.00476258,-0.0138987,-0.999794]],[[0,0,0],[1,0,0,0]]];
   !TASK PERS wobjdata Tube_holder_TH:=[FALSE,TRUE,"",[[478.116,-462.412,78.9145],[0.000553036,-0.000506896,-0.00395186,0.999992]],[[0,0,0],[1,0,0,0]]];


    PROC main()
        !grid.robhold := FALSE;
        !grid.ufprog := TRUE;
        !grid.ufmec := "";
        !grid.uframe := userFrame;
        !grid.oframe := gridPos_usF;

        !arena.robhold := FALSE;
        !arena.ufprog := TRUE;
        !arena.ufmec := "";
        !arena.uframe := userFrame;
        !arena.oframe := arenaPos_usF;

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


        !data_to_send := robot + action + action_type + target;


        !rt := CRobT();
        !rt_string := ValToStr(rt.extax);
        !SocketSend clientSocket \Str:=rt_string;

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
                IF action_type = "L" THEN
                    !MoveL targets{index_target},v100,z10,tools{index_tool};
                    MoveL targets{index_target},v100,z10,rGripper;
                    WaitRob\InPos;
                ENDIF
                IF action_type = "J" THEN
                    !MoveJ targets{index_target},v100,z10,tools{index_tool};
                    MoveJ targets{index_target},v100,z10,rGripper;
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
       !SocketClose clientSocket;
       !SocketClose serverSocket;
       ERROR
          IF ERRNO = ERR_SOCK_TIMEOUT THEN
                  RETRY;
          ENDIF
    ENDPROC
ENDMODULE
