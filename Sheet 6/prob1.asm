Data_segment_name segment para
	
	HEXA db '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

Data_segment_name ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Stack_segment_name segment para stack
	db 32h dup(0) ;define your stack segment
Stack_segment_name ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Code_segment_name segment
Main_prog proc far
assume SS:Stack_segment_name,CS:Code_segment_name,DS:Data_segment_name


	  MOV AX,Data_segment_name ; load the starting address of the data
	  MOV DS,AX ; segment into DS reg.
	  
	  ;Push binary weights to stack
	  MOV AX,1
	  PUSH AX
	  MOV AX,2
	  PUSH AX
	  MOV AX,4
	  PUSH AX
	  MOV AX,8
	  PUSH AX
	  MOV AX,16
	  PUSH AX
	  MOV AX,32
	  PUSH AX
	  MOV AX,64
	  PUSH AX
	  MOV AX,128
	  PUSH AX
	  
	  ;Count value in DX
	  MOV DX,0
	  
	  MOV CX,8
	  p1:
	  ;Read charachter
	  MOV AH,01
	  INT 21h
	  ;Get 0 or 1
	  SUB AL,30h
	  ;Pop weight to BX "BL only will be affected"
	  POP BX
	  ;Multiply weight to binary digit "result in AX"
	  MUL BL
	  ;Add result to DX
	  ADD DX,AX
	  ;Loop
	  LOOP p1
	  
	  ;Prepare Hexa
	  MOV AX,DX
	  MOV DL,16
	  DIV DL
	  ;NOW AH has AX%16 "lower digit", and AL has AX/16 "higher digit"
	  ;Store them in As Higher digit,lower digit in CX
	  MOV CH,AL
	  MOV CL,AH
	  
	  ;Print New Line
	  MOV DL,10
	  MOV AH,02h
	  INT 21h
	  
	  ;Now convert them to hexa and print
	  ;Convert higher digit
	  LEA BX,HEXA
	  MOV AL,CH
	  XLAT
	  MOV DL,AL
	  MOV AH,02h
	  INT 21h
	  ;Convert lower digit
	  MOV AL,CL
	  XLAT
	  MOV DL,AL
	  MOV AH,02h
	  INT 21h
	  
	  MOV AH,4Ch ; exit program
	  INT 21h

Main_prog endp
Code_segment_name ends
end Main_prog
