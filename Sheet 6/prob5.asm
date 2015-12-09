Data_segment_name segment para
	
	HoursTEN db ?
		  db 07
	HoursUNIT db ?
		  db 07
		  db ':'
		  db 07
	MinutesTEN db ?
		  db 07
	MinutesUNIT db ?
		  db 07
		  db ':'
		  db 07
	SecondsTEN db ?
		  db 07
	SecondsUNIT db ?
		  db 07

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
	  
	  MOV BP,10
	  
	  ClockLoop:
	  ;Get Time
	  MOV AH,2Ch
	  INT 21h
	  ;Now CH = Hours, CL = Minutes, DH = Seconds, DL = Hundredths of Seconds
	  ;Convert to ASCII Values
	  MOV AH,00
	  MOV AL,CH
	  MOV BL,10
	  DIV BL
	  ADD AX,3030h
	  MOV HoursTEN,AL
	  MOV HoursUNIT,AH
	  
	  MOV AH,00
	  MOV AL,CL
	  MOV BL,10
	  DIV BL
	  ADD AX,3030h
	  MOV MinutesTEN,AL
	  MOV MinutesUNIT,AH
	  
	  MOV AH,00
	  MOV AL,DH
	  MOV BL,10
	  DIV BL
	  ADD AX,3030h
	  MOV SecondsTEN,AL
	  MOV SecondsUNIT,AH
	  
	  MOV AX,0B800h
	  MOV ES,AX
	  MOV DI,1*80*2-8*2
	  LEA SI,HoursTEN
	  MOV CX,8
	  REP MOVSW
	  
	  JNZ ClockLoop
	  
	  MOV AH,4Ch ; exit program
	  INT 21h
	  
	  
Main_prog endp
Code_segment_name ends
end Main_prog
