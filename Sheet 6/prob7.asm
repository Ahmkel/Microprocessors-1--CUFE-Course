Data_segment_name segment para
	
	SUNDAY db 'Sunday$'
	MONDAY db 'Monday$'
	TUESDAY db 'Tuesday$'
	WEDNESDAY db 'Wednesday$'
	THURSDAY db 'Thursday$'
	FRIDAY db 'Friday$'
	SATURDAY db 'Saturday$'
	
	WeekDaysOffset dw SUNDAY,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY
	
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
	  
	  ;Get Date
	  MOV AH,2Ah
	  INT 21h
	  ;Now AL = day of the week
	  ;Multiply * 2 to get 2 bytes offset (0-6)-->(0->12)
	  MOV CL,2
	  MUL CL
	  ;Get Day string offset in AL
	  LEA BX,WeekDaysOffset
	  XLAT
	  ;Print it
	  MOV DX,AX
	  MOV AH,09h
	  INT 21h
	  
	  
	  MOV AH,4Ch ; exit program
	  INT 21h
	  
	  
Main_prog endp
Code_segment_name ends
end Main_prog
