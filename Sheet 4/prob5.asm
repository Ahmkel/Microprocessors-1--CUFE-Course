Data_segment_name segment para
	Table1 db 'W', 07h, 'e', 07h, 'l', 07h, 'c', 07h, 'o', 07h, 'm', 07h, 'e', 07h, ' ', 07h, 't', 07h, 'o', 07h, ' ', 07h, 'C', 07h, 'a', 07h, 'i', 07h, 'r', 07h, 'o', 07h, '&', '&'
Data_segment_name ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Stack_segment_name segment para stack
	;define your stack segment
Stack_segment_name ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Code_segment_name segment
Main_prog proc far
assume CS:Code_segment_name,DS:Data_segment_name
	  
	  MOV AX,Data_segment_name ; load the starting address of the data
	  MOV DS,AX ; segment into DS reg.
	  
	  MOV AH,01
	  INT 21h
	  
	  ;Increment DI
	  CLD
	  ;Prepare Destination to Compare
	  MOV AX,DS
	  MOV ES,AX
	  LEA DI,Table1
	  ;Prepare Byte to Compare to
	  MOV AL,'&'
	  MOV AH,'&'
	  ;Prepare CX to Count
	  MOV CX,0FFFFh
	  ;Start Counting Until Reach '\0\0'
	  REPNE SCASW
	  
	  NEG CX
	  DEC CX
	  DEC CX
	  
	  ;Prepare Source to Compare
	  LEA SI,Table1
	  ;Prepare Destination to Compare
	  MOV AX,0B800h
	  MOV ES,AX
	  MOV DI,0000h
	  REP MOVSW
	  
	  MOV AH,01
	  INT 21h
	  
	  
	  MOV AX,4c00h ; exit program
	  INT 21h

Main_prog endp
Code_segment_name ends
end Main_prog
