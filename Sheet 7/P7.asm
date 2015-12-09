Data_segment_name segment para
RetAddress dw ?
NAME_TABLE db 10 dup(11,0,12 dup('$'))
L1 db '143','$','$','$','$','$','$','$'
L2 db '143435879','$','$'
L3 db '143452879','$','$'
CMPStringResult db ?

MinStringAddr dw ?

AXT dw ?
BXT dw ?
CXT dw ?
DXT dw ?
BPT dw ?
SIT dw ?
DIT dw ?

Data_segment_name ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Stack_segment_name segment para stack
	db 32h dup(0FFh) ;define your stack segment
Stack_segment_name ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Code_segment_name segment
Main_prog proc far
assume SS:Stack_segment_name,CS:Code_segment_name,DS:Data_segment_name
	  
	  MOV AX,Data_segment_name
	  MOV DS,AX
	  
	  CALL InputStrings
	  CALL InsertionSort
	  CALL PrintStrings
	  	  
CLOSE:MOV AH,4Ch ; Exit program
	  INT 21h
	  
	  
Main_prog endp

SaveRegisters PROC
	MOV AXT,AX
	MOV BXT,BX
	MOV CXT,CX
	MOV DXT,DX
	MOV BPT,BP
	MOV SIT,SI
	MOV DIT,DI
	RET
SaveRegisters ENDP

LoadRegisters PROC
	MOV AX,AXT
	MOV BX,BXT
	MOV CX,CXT
	MOV DX,DXT
	MOV BP,BPT
	MOV SI,SIT
	MOV DI,DIT
	RET
LoadRegisters ENDP


InputStrings PROC
	;Save All Registers
	CALL SaveRegisters
	;Save Flags
	PUSHF
	
	  ;Input the Strings
	  MOV BX,0
OL:
	  LEA DX,NAME_TABLE[BX]
	  MOV AH,0Ah
	  INT 21h
	  MOV DL,10
	  MOV AH,02
	  INT 21h
	  ADD BX,14
	  CMP BX,14*10
	  JNZ OL
	
EXIT3:
	;Return Flags
	POPF
	;Load All Registers
	CALL LoadRegisters
	;Return
	RET
InputStrings ENDP

PrintStrings PROC
	;Save All Registers
	CALL SaveRegisters
	;Save Flags
	PUSHF
	
	MOV DL,10
	MOV AH,02h
	INT 21h
	
	  MOV BX,0
OL3:
	  LEA DX,NAME_TABLE[BX+2]
	  
	  MOV AH,09
	  INT 21h
	  MOV DL,10
	  MOV AH,02
	  INT 21h
	  
	  ADD BX,14
	  CMP BX,14*10
	  JNZ OL3
	 
EXIT5:
	;Return Flags
	POPF
	;Load All Registers
	CALL LoadRegisters
	;Return
	RET
PrintStrings ENDP

CMPString PROC
	;Save All Registers
	CALL SaveRegisters
	;Get Return Address
	POP RetAddress
	MOV AX,RetAddress
	;Get Param2 - String 2 Address
	POP DI
	;Get Param1 - String 1 Address
	POP SI
	;Save Flags
	PUSHF
	
	;Compare Strings
	MOV DX,Data_segment_name
	MOV DS,DX
	MOV ES,DX
	
	MOV CX,10
	REPE CMPSB
	JL S1LessS2
	JG S1MoreS1
	
S1EqualS2:
	MOV CMPStringResult,0
	JMP EXIT1
	
S1LessS2:
	MOV CMPStringResult,-1
	JMP EXIT1
S1MoreS1:
	MOV CMPStringResult,1
	
EXIT1:
	;Return Flags
	POPF
	;Return the Return Address
	PUSH RetAddress
	;Load All Registers
	CALL LoadRegisters
	;Return
	RET
CMPString ENDP


SwapString PROC
	;Save All Registers
	CALL SaveRegisters
	;Get Return Address
	POP RetAddress
	MOV AX,RetAddress
	;Get Param2 - String 2 Address
	POP DI
	;Get Param1 - String 1 Address
	POP SI
	;Save Flags
	PUSHF
	
	;Swap
	MOV CX,10
LOOP1:MOV AL,[SI]
	  MOV AH,[DI]
	  MOV [SI],AH
	  MOV [DI],AL
	  INC SI
	  INC DI
	  LOOP LOOP1
	
EXIT2:
	;Return Flags
	POPF
	;Return the Return Address
	PUSH RetAddress
	;Load All Registers
	CALL LoadRegisters
	;Return
	RET
SwapString ENDP

InsertionSort PROC
	;Save All Registers
	CALL SaveRegisters
	;Save Flags
	PUSHF

	  MOV BX,0
OL2:
	  LEA DX,NAME_TABLE[BX+2]
	  MOV MinStringAddr,DX
	  
	  
		  MOV SI,BX
		  ADD SI,14
	  IL:
		  LEA AX,NAME_TABLE[SI+2]
		  
		  PUSH AX
		  PUSH MinStringAddr
		  CALL CMPString
		  CMP CMPStringResult,0
		  JG NTH
		  MOV MinStringAddr,AX
		  
		  
		  NTH:
		  ADD SI,14
		  CMP SI,14*10
		  JNZ IL
		  
		  
	  Push MinStringAddr
	  Push DX
	  CALL SwapString
	  
	  ADD BX,14
	  CMP BX,14*9
	  JNZ OL2
		
EXIT4:
	;Return Flags
	POPF
	;Load All Registers
	CALL LoadRegisters
	;Return
	RET
InsertionSort ENDP

Code_segment_name ends
end Main_prog
