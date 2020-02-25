
;--------------------------------------
        .MODEL  SMALL
        .STACK  100
        EXTRN   input: FAR
        EXTRN   concat: FAR
        EXTRN   compare: FAR
        EXTRN   substr1: FAR
        .DATA
;---------------------------------------
CR      EQU     0DH
LF      EQU     0AH
MENU    DB      CR,LF,CR,LF,'MENU:-',CR,LF,'(1)Input String',CR,LF,'(2)Concatenate String',CR,LF,'(3)String compare',CR,LF,'(4)Substring',CR,LF,'(5)String details',CR,LF,'(6)Exit',CR,LF,'$'
MSG1    DB      CR,LF,'Enter choice : ',CR,LF,'$'
MSG2    DB      CR,LF,'Conctenated String is : ','$'
;---------------------------------------
        .CODE
MAIN    PROC    FAR
        MOV     AX,@data
        MOV     DS,AX

START:  MOV     AH,09H
        LEA     DX,MENU
        INT     21H
        MOV     AH,09H
        LEA     DX,MSG1
        INT     21H                 ;prints menu

        MOV     AH,01H
        INT     21H
        CMP     AL,'1'
        JE      INP
        CMP     AL,'2'
        JE     CONCATENATE
        CMP     AL,'3'
        JE      COMP
        CMP     AL,'4'
        JE      SB
        CMP     AL,'6'
        JMP     EXIT			;switch-case

INP:    CALL    input
        JMP     START

            
CONCATENATE:    MOV     AH,09H
                LEA     DX,MSG2
                INT     21H                 ;prints menu
                CALL    concat
                JMP     START

COMP:   CALL    compare
        JMP     START

SB:     CALL    substr1
        JMP     START

EXIT:   MOV     AX,4C00H
        INT     21H
MAIN    ENDP
        END     MAIN
