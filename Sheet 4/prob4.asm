Data_segment_name segment para
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
	  
	  ;;;;Clear Screen
	  ;Increment DI
	  CLD
	  ;Prepare Destination Address
	  MOV AX,0B800h
	  MOV ES,AX
	  MOV DI,0*80*2
	  ;Prepare Data to be Copied
	  MOV AX,0620h
	  ;Begin Looping and Copying Data
	  MOV CX,25*80
	  rep STOSW
	  
	  MOV AH,01
	  INT 21h
	  
	  
	  MOV AX,4c00h ; exit program
	  INT 21h

Main_prog endp
Code_segment_name ends
end Main_prog
