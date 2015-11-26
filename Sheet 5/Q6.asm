Data_segment_name segment para
	InputMessage1 db 'Input integer a: $'
	InputMessage2 db 10,13,'Input integer b: $'
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

	  ;Read integer a Most Significant digit ascii in AL using DOS API
	  LEA DX,InputMessage1
	  MOV AH,09h
	  INT 21h
	  MOV AH,01h
	  INT 21h
	  ;Store digit in BH
	  MOV BH,AL
	  ;Read integer a Least Significant digit ascii in AL using DOS API
	  MOV AH,01h
	  INT 21h
	  ;Store digit to BL
	  MOV BL,AL
	  ;;;Now BX has integer a
	  

	  ;Read integer b Most Significant digit ascii in AL using DOS API
	  LEA DX,InputMessage2
	  MOV AH,09h
	  INT 21h
	  MOV AH,01h
	  INT 21h
	  ;Store digit in DH
	  MOV CH,AL
	  ;Read integer b Least Significant digit ascii in AL using DOS API
	  MOV AH,01h
	  INT 21h
	  ;Store digit to DL
	  MOV CL,AL
	  ;;;Now CX has integer b
	  
	  ;Start Addition Process
	  ;;Add LS digits first in AL then adjust
	  MOV AH,00h
	  MOV AL,BL
	  ADD AL,CL
	  ;;Adjust
	  AAA
	  ;;Store final Answer in DX
	  MOV DX,AX
	  ;;Add MS digits then add Carry(Which is in DH) in AL then adjust
	  MOV AH,00h
	  MOV AL,BH
	  ADD AL,CH
	  ;;Adjust
	  AAA
	  ;;Reconvert AL to ascii
	  ADD AL,30h
	  ;;Reconvert the Carry to ascii
	  ADD DH,30h
	  ;;Add the Carry
	  ADD AL,DH
	  ;;Adjust again
	  AAA
	  ;;Store final Answer in BX
	  MOV BX,AX
	  ;;;Now our Result consists of 3 digits stored from left to right in BH,BL,DL in decimal BCD format
	  ;;;Copy From DL to CL because we need DL
	  MOV CL,DL
	  ;;;Now our Result consists of 3 digits stored from left to right in BH,BL,CL in decimal BCD format
	  ;;;Convert them to ascii format
	  ADD BX,3030h
	  ADD CL,30h
	  
	  ;Copy to and Ouput result digits ascii from DL to SCREEN using DOS API
	  LEA DX,ResultMessage
	  MOV AH,09h
	  INT 21h
	  ;;Copy Result most significant digit to DL and Output
	  MOV DL,BH
	  MOV AH,02h
	  INT 21h
	  ;;Copy Result mid digit to DL and Output
	  MOV DL,BL
	  MOV AH,02h
	  INT 21h
	  ;;Copy Result least significant digit to DL and Output
	  MOV DL,CL
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
