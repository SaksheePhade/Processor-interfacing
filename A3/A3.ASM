        .MODEL  SMALL
        .STACK  100
        .DATA
;---------------------------------------
CR      EQU     0DH
LF      EQU     0AH
MENU    DB      CR,LF,'MENU:-',CR,LF,'(1)String input',CR,LF,'(2)String length',CR,LF,'(3)String reverse',CR,LF,'(4)Check if Palindrome',CR,LF,'(5)Exit',CR,LF,'$'
MSG1    DB      CR,LF,'Enter string : ','$'
MSG2    DB      CR,LF,'Enter choice : ','$'
MSG3    DB      CR,LF,'Length of the string is : ','$'
MSG4    DB      CR,LF,'String reverse is : ','$'
MSG5    DB      CR,LF,'Given string is a palindrome.','$'
MSG6    DB      CR,LF,'Given string is not a palindrome.','$'
MSG7    DB      CR,LF,'Given string is : ','$'
STRING  DB      30 DUP('$')
length1 DB      ?
ARR     DB      30 DUP('$')
ARR1    DB      30 DUP('$')
;---------------------------------------
        .CODE
MAIN    PROC    FAR
        MOV     AX,@data
        MOV     DS,AX

START:  MOV     AH,09H
        LEA     DX,MENU
        INT     21H
        MOV     AH,09H
        LEA     DX,MSG2
        INT     21H                 ;prints menu

        MOV     AH,01H
        INT     21H
        CMP     AL,'1'
        JE      INP
        CMP     AL,'2'
        JE      LEN
        CMP     AL,'3'
        JE      REV
        CMP     AL,'4'
        JE      PALIN
        CMP     AL,'5'
        JMP     EXIT			;switch-case


INP:    MOV     AH,09H
        LEA     DX,MSG1
        INT     21H      
        CALL    input
        JMP     START

LEN:    MOV     AH,09H
        LEA     DX,MSG3
        INT     21H      
        CALL    strlen
        JMP     START

REV:    MOV     AH,09H
        LEA     DX,MSG4
        INT     21H      
        CALL    strrev
        JMP     START

PALIN:  CALL    palindrome
        JMP     START


        PROC    input

        MOV     AH,0AH
        LEA     DX,STRING              ;input string
        INT     21H

        MOV     AH,09H
        LEA     DX,MSG7                ;Given string is,
        INT     21H

        MOV     AH,09H
        LEA     DX,STRING+2            ;prints string
        INT     21H

        RET
        ENDP

        PROC    strlen
        LEA     SI,STRING
        INC     SI
        MOV     BL,[SI]
        MOV     length1,BL             ;prints string length
        ADD     BL,30H
        MOV     AH,02H
        MOV     DL,BL
        INT     21H
        RET
        ENDP

        PROC    strrev

        LEA     DI,ARR
        LEA     SI,STRING
        INC     SI
        MOV     CH,length1
        INC     SI
     LP:INC     DI           ;loop inc di
        DEC     CH
        JNZ     LP
        DEC     DI
        MOV     CH,length1
    LP1:MOV     BL,[SI]      ;stores reverse list in arr
        MOV     [DI],BL
        INC     SI
        DEC     DI
        DEC     CH
        JNZ     LP1
        LEA     DI,ARR
        MOV     CH,length1
    LP2:MOV     BL,[DI]
        MOV     AH,02H
        MOV     DL,BL
        INT     21H
        INC     DI
        DEC     CH
        JNZ     LP2

        RET
        ENDP

        PROC    palindrome

        LEA     DI,ARR1
        LEA     SI,STRING+1
        MOV     CH,[SI]
        INC     SI
    LP4:MOV     BL,[SI]
        MOV     [DI],BL
        INC     SI
        INC     DI
        DEC     CH
        JNZ     LP4

        DEC     DI
        LEA     SI,STRING
        INC     SI
        INC     SI
        MOV     CH,length1

    LP3:MOV     BL,[SI]
        MOV     BH,[DI]
        CMP     BH,BL
        JNE     no
        INC     SI
        DEC     DI
        DEC     CH
        JNZ     LP3

        MOV     AH,09H
        LEA     DX,MSG5
        INT     21H
        JMP     rest

    no: MOV     AH,09H
        LEA     DX,MSG6
        INT     21H

  rest: RET
        ENDP

EXIT:   MOV     AX,4C00H
        INT     21H
MAIN    ENDP
        END     MAIN


















