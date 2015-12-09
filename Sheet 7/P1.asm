Data_segment_name segment para
VALUE DW ?
Data_segment_name ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Stack_segment_name segment para stack
	db 32h dup(0) ;define your stack segment
Stack_segment_name ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Code_segment_name segment
Main_prog proc far
assume SS:Stack_segment_name,CS:Code_segment_name,DS:Data_segment_name
	  
	  
	  MOV AX,Data_segment_name
	  MOV DS,AX
	  
	  MOV AH,01h
	  INT 21h
	  SUB AL,'0'
	  MOV CL,100
	  MUL CL
	  MOV BX,AX
	  
	  MOV AH,01h
	  INT 21h
	  SUB AL,'0'
	  MOV CL,10
	  MUL CL
	  ADD BX,AX
	  
	  MOV AH,01h
	  INT 21h
	  SUB AL,'0'
	  MOV AH,00h
	  ADD BX,AX
	  
	  MOV VALUE,BX
	  
	  MOV DL,10
	  MOV AH,02h
	  INT 21h
	  
	  MOV BX,8000h
	  MOV CX,16
BIN:  
	  TEST VALUE,BX
	  JNZ ONE
	  
	  MOV DL,'0'
	  MOV AH,02h
	  INT 21h
	  JMP EL
	  
ONE:  MOV DL,'1'
	  MOV AH,02h
	  INT 21h
	  
EL:	  SHR BX,1
	  LOOP BIN
	  
CLOSE:MOV AH,4Ch ; Exit program
	  INT 21h
	  
	  
Main_prog endp
Code_segment_name ends
end Main_prog
