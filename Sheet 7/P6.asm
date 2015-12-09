Data_segment_name segment para
KEY db 'B',07h,'U',07h,'G',07h,0
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
	  
	  MOV AX,0B800h
	  MOV ES,AX
	  
	  MOV AL,0
	  
	  MOV CX,0
CHECK:
	  LEA SI,KEY
	  MOV DI,CX
	  
KEYCMP:CMPSB
	  JZ KEYCMP
	  CMP [SI],AL ;IF equal then it reached the 0 value in key correctly, therefoe it found the word 'BUG' (All previous comparisons true) 
	  JZ YES
	  
	  ADD CX,2
      CMP CX,25*80*2 - 2*2 + 1*2
	  JNZ CHECK

	  MOV DL,'N'
	  MOV AH,02
	  INT 21h
	  JMP CLOSE
	  
YES:  MOV DL,'Y'
	  MOV AH,02
	  INT 21h
	  
CLOSE:MOV AH,4Ch ; Exit program
	  INT 21h
	  
	  
Main_prog endp
Code_segment_name ends
end Main_prog
