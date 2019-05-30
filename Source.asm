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
nombre db "imagen16MonoEscalada.raw",0
nombre1 db "imgPruebaBin.raw",0
handle dd ?
conts db 16 dup(9)
imagen dd 213000 dup(?)
imagenProm dd 213000 dup(?)

cc1 dd 86
cc2 dd 297

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
	MOVUPS XMM5,OWORD PTR conts
	MOVups xmm0,OWORD PTR imagen[EBX*8]
	MOVUPS xmm1,OWORD PTR imagen[EBX*8+1]
	MOVUPS XMM2,OWORD PTR imagen[EBX*8+2]
	addps  xmm0 ,  xmm1 
	ADDPS XMM0,XMM2
	ADD EBX,710	
	MOVUPS XMM3, OWORD PTR imagen[EBX*8]
	MOVUPS XMM1,OWORD PTR imagen[EBX*8+1]
	MOVUPS XMM2,OWORD PTR imagen[EBX*8+2]	
	ADDPS XMM0,XMM3
	ADDPS XMM0,XMM2
	ADDPS XMM0,XMM1
	ADD EBX,1420
	MOVUPS XMM3, OWORD PTR imagen[EBX*8]
	MOVUPS XMM1,OWORD PTR imagen[EBX*8+1]
	MOVUPS XMM2,OWORD PTR imagen[EBX*8+2]
	ADDPS XMM0,XMM3
	ADDPS XMM0,XMM2
	ADDPS XMM0,XMM1
	DIVPS XMM0,XMM5

	MOVUPS OWORD PTR imagenProm[EDI*8],XMM0
	inc EDI
	DEC ECX
	JNE cicloFilas
	;en lugar de usar loop usar decremento con salto condicional ""go to
	;loop cicloFilas	
	pop ECX
	;loop cicloColumnas
	DEC ECX
	JNE cicloColumnas

	call creaArchivo
	call escribirArchivo

INVOKE ExitProcess,0
main ENDP

promedio proc

promedio endp
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
	push 213000 ;Numero de caracteres a escribir
	push offset imagenProm
	push handle
	call WriteFile
ret
escribirArchivo endp


leerArchivo proc
	call abrirArchivo
	push 0
	push 0
	push 213000
	push offset imagen
	push handle
	call ReadFile
ret
leerArchivo endp
END