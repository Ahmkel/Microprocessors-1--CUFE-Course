Data_segment_name segment para
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
	  
	  MOV AH,01
	  INT 21h
	  ;Prepare Destination Address
	  mov DI,0000h
	  mov AX,0B800h
	  mov ES,AX
	  ;increment DI
	  cld
	  ;Prepare Data to be Copied
	  mov AX,0732h
	  ;Begin Looping and Copying Data
	  mov CX,200
	  rep stosw
	  
	  MOV AH,01
	  INT 21h
mov ax,4c00h ; exit program
int 21h

Main_prog endp
Code_segment_name ends
end Main_prog
