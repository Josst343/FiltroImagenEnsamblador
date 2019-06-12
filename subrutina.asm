.386
	.MODEL SMALL , stdcall
	ExitProcess PROTO, dwExitCode:DWORD
    .DATA
	datos DB 8,6,9
	actual db 0
	numM db 0
    .CODE
    ASSUME DS:_DATA
main PROC
	MOV EAX ,0
	MOV EAX, offset datos
	call mayor
	
	MOV EAX,0
	MOV AL,numM
	INVOKE ExitProcess,0
main ENDP
mayor PROC NEAR
	MOV ESI,0
	MOV EBX,0
	MOV ECX,0
	MOV BL,[EAX+ESI]
	INC SI
	MOV CL,[EAX+ESI]
	mov numM,bl
	CMP numM,cl
	JC actualesMenor
	JNZ esMayor
	actualesMenor:
		mov numM,cl
	esMayor:
		
	INC SI
	MOV CL,[EAX+ESI]
	CMP numM,CL
	JC numMesMenor
	JNZ numMesMayor
	numMesMenor:
		mov numM,cl
		ret	
	numMesMayor:

	
	RET 
mayor ENDP
	
END