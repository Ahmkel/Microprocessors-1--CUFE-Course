Data_segment_name segment para
	
	LINE db 81,82 dup(?)

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
	  
	  
	  LEA DX,LINE
	  MOV AH,0Ah
	  INT 21h
	  
	  MOV DL,10
	  MOV AH,02h
	  INT 21h
	  
	  ;Convert number from decimal to ascii
	  MOV AH,00
	  MOV AL,LINE+1
	  MOV CL,10
	  DIV CL
	  ;Now AH contains AX%10 and AL containts AX/10
	  ADD AX,3030h
	  ;Store MS digit in CH, LS digit in CL
	  MOV CH,AL
	  MOV CL,AH
	  ;Print MS digit
	  MOV DL,CH
	  MOV AH,02h
	  INT 21h
	  ;Print LS digit
	  MOV DL,CL
	  MOV AH,02h
	  INT 21h
	  
	  MOV AH,4Ch ; exit program
	  INT 21h
	  
	  
Main_prog endp
Code_segment_name ends
end Main_prog
