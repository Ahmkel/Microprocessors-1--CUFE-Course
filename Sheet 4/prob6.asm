Data_segment_name segment para
	Lines dw 2*80 dup(0)
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
	  
	  ;;;;I added interrupts between before step so that the output can be seen on the screen
	  MOV AH,01
	  INT 21h
	  
	  ;Store DS
	  MOV DX,DS
	  
	  ;;;;Save First Two Line
	  MOV AX,DS
	  MOV ES,AX
	  LEA DI,Lines
	  MOV AX,0B800h
	  MOV DS,AX
	  MOV SI,0*80*2
	  MOV CX,2*80
	  CLD
	  rep MOVSW
	  
	  ;;;;I added interrupts between each step so output can be seen on the screen
	  MOV AH,01
	  INT 21h
	  
	  ;;;;Scroll Up
	  ;Prepare Source Address
	  MOV AX,0B800h
	  MOV DS,AX
	  MOV SI,2*80*2
	  ;Prepare Destination Address
	  MOV AX,0B800h
	  MOV ES,AX
	  MOV DI,0*80*2
	  ;Increment DI
	  CLD
	  ;Begin Looping and Copying Data
	  MOV CX,23*80
	  rep MOVSW
	  
	  MOV AH,01
	  INT 21h
	  
	  ;;;;Clear Last Two Lines
	  ;Prepare Data to be Copied
	  MOV AX,0720h
	  ;Increment DI
	  CLD
	  ;Prepare Destination Address
	  MOV DI,23*80*2
	  ;Begin Looping and Copying Data
	  MOV CX,2*80
	  rep STOSW
	  
	  MOV AH,01  ; keyboard input with echo
	  INT 21h
	  
	  ;;;;Scroll Down
	  ;Prepare Source Address
	  MOV AX,0B800h
	  MOV DS,AX
	  MOV SI,23*80*2-2
	  ;Prepare Destination Address
	  MOV AX,0B800h
	  MOV ES,AX
	  MOV DI,25*80*2-2
	  ;Decrement DI
	  STD
	  ;Begin Looping and Copying Data
	  MOV CX,23*80
	  rep MOVSW
	  
	  MOV AH,01  ; keyboard input with echo
	  INT 21h
	  
	  ;;;;Restore First Two Lines
	  MOV DS,DX
	  LEA SI,Lines
	  MOV AX,0B800h
	  MOV ES,AX
	  MOV DI,0*80*2
	  MOV CX,2*80
	  CLD
	  rep MOVSW
	  
	  MOV AH,01  ; keyboard input with echo
	  INT 21h
		
mov ax,4c00h ; exit program
int 21h

Main_prog endp
Code_segment_name ends
end Main_prog
