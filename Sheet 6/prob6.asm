Data_segment_name segment para
	
	January db 'January$'
	February db 'February$'
	March db 'March$'
	April db 'April$'
	May db 'May$'
	June db 'June$'
	July db 'July$'
	August db 'August$'
	September db 'September$'
	October db 'October$'
	November db 'November$'
	December db 'December$'
	
	MonthsOffset dw January,February,March,April,May,June,July,August,September,October,November,December
	
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
	  
	  ;Get MS digit
	  MOV AH,01h
	  INT 21h
	  ;Convert to digit
	  SUB AL,30h
	  ;Now AL = MS digit
	  ;Multiply it * 10 because it is the Tenths digit
	  MOV CL,10
	  MUL CL
	  ;Store Number in DH
	  MOV DH,AL
	  ;Read LS digit
	  MOV AH,01h
	  INT 21h
	  ;Convert to digit
	  SUB AL,30h
	  ;Now AL = MS digit
	  ;Add MS digit in DH to LS digit in DH
	  ADD AL,DH
	  ;DEC AL to get 0 to 11 offset (1-12)-->(0-11)
	  DEC AL
	  ;Multiply * 2 to get 2 bytes offset (0-11)-->(0->22)
	  MOV CL,2
	  MUL CL
	  
	  
	  
	  ;Get Months string offset in AX
	  LEA BX,MonthsOffset
	  XLAT
	  
	  ;Store it in BX
	  MOV BX,AX
	  
	  ;Print New Line
	  MOV DL,10
	  MOV AH,02h
	  INT 21h
	  
	  ;Print it
	  MOV DX,BX
	  MOV AH,09h
	  INT 21h
	  
	  
	  MOV AH,4Ch ; exit program
	  INT 21h
	  
	  
Main_prog endp
Code_segment_name ends
end Main_prog
