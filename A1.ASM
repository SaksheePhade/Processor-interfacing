
;----------------------------------------------------------------
       .MODEL        SMALL
       .STACK        64
       .DATA
;----------------------------------------------------------------
CR      EQU          0DH
LF      EQU          0AH
ARR     DB           30 DUP(0)
;a       DB           ?
;SUM     DB           00H   
SUMH    DB           00H
SUML    DB           00H
MSG     DB           CR,LF, 'Enter size of array : ','$'
MSG2    DB           CR,LF,'Enter array element : ','$'
MSG3    DB           CR,LF,'Array elements : ','$',CR,LF
RES     DB           CR,LF,'Addition result : ','$'
;----------------------------------------------------------------
        .CODE
MAIN    PROC         FAR
        MOV          AX,@DATA
        MOV          DS,AX

        MOV          AH,09H
        LEA          DX,MSG
        INT          21H
        MOV          AH,01H
        INT          21H                ;takes array size

        MOV          CL,AL              ;sets counter to arraysize
        SUB          CX,30H
        MOV          BX,CX

        LEA          SI,ARR             ;loads address of array in SI

LOOP1:  MOV          AH,9
        LEA          DX,MSG2
        INT          21H                ;takes array element
        MOV          AH,01H
        INT          21H
        MOV          [SI],AL
        INC          SI
        MOV          AH,01H
        INT          21H
        MOV          [SI],AL
        INC          SI
        LOOP         LOOP1

        LEA          SI,ARR
        MOV          CX,BX

        MOV          AH,09H
        LEA          DX,MSG3
        INT          21H
        
LOOP2:  MOV          AH,02H
        MOV          DL,[SI]            ;prints array elements
        INT          21H
        MOV          AH,02H
        INC          SI
        MOV          DL,[SI]            ;prints array elements
        INT          21H
        MOV          AH,02H   
        MOV          DL,2CH
        INT          21H
        INC          SI
        LOOP         LOOP2

        MOV          CX,BX
        LEA          SI,ARR   
        MOV          AX,00H

LOOP3:  MOV          BH,[SI]
        INC          SI
        MOV          BL,[SI]
        ADD          AX,BX
        AAA 
        SUB          AH,30H  
        INC          SI
        LOOP         LOOP3

        ADD          AH,30H
        ADD          AL,30H

        MOV          BX,00H
        MOV          SUMH,AH
        MOV          SUML,AL
        MOV          AX,00H
        MOV          BL,SUMH
        ADD          AL,BL
        AAA
        MOV          BH,AH
        ADD          BH,30H
        MOV          BL,AL
        ADD          BL,30H
        MOV          AH,9
        LEA          DX,RES
        INT          21H
        MOV          AH,02H
        MOV          DL,BH             ;prints sum
        INT          21H
        MOV          AH,02H
        MOV          DL,BL
        INT          21H
        MOV          AH,02H
        MOV          DL,SUML             ;prints sum
        INT          21H

        MOV          AX,4C00H
        INT          21H
MAIN    ENDP

        END      MAIN
