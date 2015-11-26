Data_segment_name segment para
	InputMessage1 db 'Input Character: $'
	InputMessage2 db 10,13,'Input Attribute: $'
	InputMessage3 db 10,13,'Input Column: $'
	InputMessage4 db 10,13,'Input Row: $'
	ByeMessage db 10,13,'Bye$'
	Character db ?
	Attribute db ?
	Column db ?
	Row db ?
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

	  ;Read Character ascii in AL using DOS API
	  LEA DX,InputMessage1
	  MOV AH,09h
	  INT 21h
	  MOV AH,01h
	  INT 21h
	  ;Store Character in CH
	  MOV Character,AL
	  
	  ;Read Character Attribute as 3 decimal digits in AL using DOS API
	  LEA DX,InputMessage2
	  MOV AH,09h
	  INT 21h
	  ;;Read Most Significant Digit
	  MOV AH,01h
	  INT 21h
	  ;Store *100 to Attribute
	  SUB AL,30h
	  MOV CL,100
	  MUL CL
	  MOV Attribute,AL
	  ;;Read Mid Digit
	  MOV AH,01h
	  INT 21h
	  ;Add *10 to Attribute
	  SUB AL,30h
	  MOV CL,10
	  MUL CL
	  ADD Attribute,AL
	  ;;Read Least Significant Digit
	  MOV AH,01h
	  INT 21h
	  ;Add to Attribute
	  SUB AL,30h
	  ADD Attribute,AL
	  
	  ;Read Column in AL using DOS API
	  LEA DX,InputMessage3
	  MOV AH,09h
	  INT 21h
	  ;;Read Most Significant Digit
	  MOV AH,01h
	  INT 21h
	  ;Store Column *10 in DS:Column
	  SUB AL,30h
	  MOV CL,10
	  MUL CL
	  MOV Column,AL
	  ;;Read Least Significant Digit
	  MOV AH,01h
	  INT 21h
	  ;Add Column to DS:Column
	  SUB AL,30h
	  ADD Column,AL
	  
	  ;Read Column in AL using DOS API
	  LEA DX,InputMessage4
	  MOV AH,09h
	  INT 21h
	  ;;Read Most Significant Digit
	  MOV AH,01h
	  INT 21h
	  ;Store Column *10 in DS:Row
	  SUB AL,30h
	  MOV CL,10
	  MUL CL
	  MOV Row,AL
	  ;;Read Least Significant Digit
	  MOV AH,01h
	  INT 21h
	  ;Add Column to DS:Row
	  SUB AL,30h
	  MOV AH,00
	  ADD Row,AL
	  
	  MOV AX,0B800h
	  MOV ES,AX
	  MOV AH,00h
	  MOV AL,Row
	  MOV CL,80*2
	  MUL CL
	  MOV DI,AX
	  
	  MOV AH,00h
	  MOV AL,Column
	  MOV CL,2
	  MUL CL
	  ADD DI,AX
	  MOV AL,Character
	  MOV AH,Attribute
	  STOSW
	  
	  MOV AH,01h
	  INT 21h
	  
	  ;Output Bye Message
	  LEA DX,ByeMessage
	  MOV AH,09h
	  INT 21h
	  
	  
mov ax,4c00h ; exit program
int 21h

Main_prog endp
Code_segment_name ends
end Main_prog
