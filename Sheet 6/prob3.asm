Data_segment_name segment para
	
	HELLO db 'HELLO$'

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
	  
	  
	  LEA DX,HELLO
	  MOV AH,09h
	  INT 21h
	  
	  MOV AH,4Ch ; exit program
	  INT 21h
	  
	  
Main_prog endp
Code_segment_name ends
end Main_prog