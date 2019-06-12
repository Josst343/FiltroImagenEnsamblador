.586
.model flat, stdcall
.stack  1024
.xmm
;Prototipos de las funciones
ExitProcess PROTO, :DWORD
CreateFileA PROTO, :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteFile PROTO, :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadFile PROTO, :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
.data 
nombre db "imgPruebaMono32F.raw",0
nombre1 db "imgPruebaBin.raw",0
handle dd ?
conts dd 4 dup(9.0)
imagen dw 426000 dup(?)
imagenProm dw 426000 dup(?)
cc1 dd 88
cc2 dd 300
nueve dw 9

.code
main PROC

	call leerArchivo
	MOV EBX,0
	MOV EDI,0
	MOV ECX,cc2
	
	cicloColumnas:
	push ECX

	mov ECX,cc1	
	cicloFilas:
	mov EBX,EDI
	mov esi,ebx
	
	MOVUPS XMM5,OWORD PTR conts
	MOVUPS xmm0,OWORD PTR imagen[EBX*4]
	MOVUPS xmm1,OWORD PTR imagen[EBX*4+4]
	ADDPS xmm0,xmm1
	MOVUPS XMM1,OWORD PTR imagen[EBX*4+8]
	addps  xmm0 ,xmm1 
	ADD EBX,710	
	MOVUPS XMM1, OWORD PTR imagen[EBX*4]
	ADDPS XMM0,XMM1
	MOVUPS XMM1,OWORD PTR imagen[EBX*4+4]
	ADDPS XMM0,XMM1
	MOVUPS XMM1,OWORD PTR imagen[EBX*4+8]	
	ADDPS XMM0,XMM1
	ADD EBX,1420
	MOVUPS XMM1, OWORD PTR imagen[EBX*4]
	ADDPS XMM0,XMM1
	MOVUPS XMM1,OWORD PTR imagen[EBX*4+4]
	ADDPS XMM0,XMM1
	MOVUPS XMM1,OWORD PTR imagen[EBX*4+8]
	ADDPS XMM0,XMM1
	DIVPS XMM0,XMM1
	
	MOVUPS OWORD PTR imagenProm[EDI*4],XMM0
	
	inc EDI
	inc EDI
	inc EDI
	inc EDI
	DEC ECX
	JNE cicloFilas

	;loop cicloFilas	
	pop ECX
	;loop cicloColumnas
	DEC ECX
	JNE cicloColumnas

	call creaArchivo
	call escribirArchivo

INVOKE ExitProcess,0
main ENDP



creaArchivo proc
	push 0
	push 20H
	push 2
	push 0
	push 3
	push 0C0000000h
	push offset nombre1
	call CreateFileA
	mov handle,eax

ret
creaArchivo endp

abrirArchivo proc
	push 0
	push 20H
	push 3
	push 0
	push 3
	push 0C0000000h
	push offset nombre
	call CreateFileA
	mov handle,eax

ret
abrirArchivo endp

escribirArchivo proc
	push 0
	push 0
	push 426000 ;Numero de caracteres a escribir
	push offset imagenProm
	push handle
	call WriteFile
ret
escribirArchivo endp


leerArchivo proc
	call abrirArchivo
	push 0
	push 0
	push 426000
	push offset imagen
	push handle
	call ReadFile
ret
leerArchivo endp
END