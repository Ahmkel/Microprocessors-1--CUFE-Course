Data_segment_name segment para
	InputMessage1 db 'Input digit 1: $'
	InputMessage2 db 10,13,'Input digit 2: $'
	ResultMessage db 10,13,'The result is: $'
	ByeMessage db 10,13,'Bye$'
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
	  ;Read digit 1 ascii in AL using DOS API
	  LEA DX,InputMessage1
	  MOV AH,09h
	  INT 21h
	  MOV AH,01h
	  INT 21h
	  ;Store digit ascii in BL
	  MOV BL,AL
	  ;Read digit 2 ascii in AL using DOS API
	  LEA DX,InputMessage2
	  MOV AH,09h
	  INT 21h
	  MOV AH,01h
	  INT 21h
	  ;Set AH to Zero to Adjust value 16 bit to handle 2 digits
	  MOV AH,00h
	  ;Add digit 1 ascii from BL to digit 1 ascii in AL
	  ADD AL,BL
	  ;Adjust result in AL from ascii in AL to 2 digit BCD in AX
	  AAA
	  ;Store Result in BX
	  MOV BX,AX
	  ;Convert Result 2 BCD digits in BX to ascii format
	  ADD BX,3030h
	  ;Copy to and Ouput result digits ascii from DL to SCREEN using DOS API
	  LEA DX,ResultMessage
	  MOV AH,09h
	  INT 21h
	  ;;Copy Result most significant digit to DL and Output
	  MOV DL,BH
	  MOV AH,02h
	  INT 21h
	  ;;Copy Result least significant digit to DL and Output
	  MOV DL,BL
	  MOV AH,02h
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
