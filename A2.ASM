        .MODEL  SMALL
        .STACK  100
        .DATA
;---------------------------------------
CR      EQU     0DH
LF      EQU     0AH
MENU    DB      CR,LF,'MENU:-',CR,LF,'(1)Hex to BCD',CR,LF,'(2)BCD to HEX',CR,LF,'(3)Exit','$'
MSG1    DB      CR,LF,'Hex to BCD : ','$'
MSG2    DB      CR,LF,'LABEL2','$'
MSG3    DB      CR,LF,'LABEL3','$'
MSG4    DB      CR,LF,'ENTER CHOICE: ','$'
MSG5    DB      CR,LF,'HEX TO DEC : ','$'
MSG6    DB      CR,LF,'ENTER HEX NUMBER : ','$'
DECI    DB      CR,LF,'DECIMAL NUMBER : ','$'
MSG7     DB      CR,LF,'BCD NUMBER : ','$'
choice  DB      ?
num     DW      0
ARR     DB      10 DUP(?)
BIN     DB      10 DUP(?)
;---------------------------------------
        .CODE
MAIN    PROC    FAR
        MOV     AX,@data
        MOV     DS,AX

        MOV     AH,09H
        LEA     DX,MENU
        INT     21H

        MOV     AH,09H
        LEA     DX,MSG4
        INT     21H                ;MENU

        MOV     AH,01H
        INT     21H

        MOV     choice,AL
       ; CMP     choice,'1'
       ; JE      LABEL1
         JMP     LABEL1
       ; CMP     choice,'2'
       ; JE      LABEL2
       ; JMP      LABEL4

LABEL1: MOV     AH,09H
        LEA     DX,MSG1
        INT     21H
        CALL    hextobcd
        JMP     LABEL4

        PROC    hextobcd        
        MOV     AH,09H
        LEA     DX,MSG6
        INT     21H

        MOV     CH,4
        MOV     CL,4


LP1:    MOV     AH,01H
        INT     21H
        CMP     AL,40H
        JGE     ALPHA
        JMP     REST

ALPHA:  SUB     AL,7H
        JMP     REST

REST:   SUB     AL,30H
        MOV     AH,00H
        ADD     BX,AX
        CMP     CH,1
        JE      BRK
        ROL     BX,CL
BRK:    DEC     CH
        JNZ     LP1

        LEA     SI,ARR
        MOV     AX,BX
        MOV     DX,0000H
        MOV     BX,000AH

LP2:    DIV     BX
        MOV     [SI],DX
        INC     SI
        MOV     DX,0000H
        CMP     AX,0000H
        JNZ     LP2            

        MOV     BX,00H
        MOV     CH,5
        DEC     SI
        MOV     AH,09H
        LEA     DX,DECI
        INT     21H

PRNTDEC:MOV     AL,[SI]
        ADD     AL,30H
        MOV     AH,02H
        MOV     DL,AL
        INT     21H
        DEC     SI
        DEC     CH
        JNZ     PRNTDEC

        LEA     SI,ARR
        MOV     DX,0000H
        MOV     BX,0002H
        MOV     AH,00H
        LEA     DI,BIN
        MOV     CL,5

BCD:    MOV     AL,[SI]

        MOV     CH,4
LP3:    DIV     BX
        MOV     [DI],DX
        MOV     DX,0000H
        INC     DI
        DEC     CH
        JNZ     LP3        ;inner loop for 1 digit

        INC     SI
        DEC     CL
        JNZ     BCD        ;loop for 5 digits

        DEC     DI
        MOV     CH,20
        MOV     AH,09H
        LEA     DX,MSG7
        INT     21H
        LEA     DI,BIN

PRNTBCD:MOV     AL,[DI]
        ADD     AL,30H
       ; MOV     CL,4
        MOV     AH,02H
        MOV     DL,AL
        INT     21H
        INC     DI
        DEC     CH
        JNZ     PRNTBCD
        RET
        ENDP
    

LABEL2: MOV     AH,09H
        LEA     DX,MSG2
        INT     21H
        JMP     MAIN

LABEL3: MOV     AH,09H
        LEA     DX,MSG3
        INT     21H
        JMP     MAIN

LABEL4:
        MOV     AX,4C00H
        INT     21H
MAIN    ENDP
        END     MAIN


