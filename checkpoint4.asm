extern malloc
extern free
extern fprintf

section .data
    null_msg db "NULL", 0      ; Mensaje para imprimir si el string es vacío
section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a[rdi], char* b[rsi])
strCmp:
	;prologo
	push rbp
	mov rbp, rsp

	cicloCmp:
		mov r8b, byte[rdi] ; r8b =  char A
		mov cl, byte[rsi] ; cl =  char B
		cmp r8b, cl
		jnz sonDistintos
		cmp r8b, 0
		jz sonIguales
		add rdi, 1
		add rsi, 1
	jmp cicloCmp

	sonDistintos:
		cmp r8b, cl
		jg aEsMayor
		jmp bEsMayor

	aEsMayor:
		mov eax, -1
		jmp terminarCmp

	bEsMayor:
		mov eax, 1
		jmp terminarCmp

	sonIguales:
		mov eax, 0
		jmp terminarCmp

terminarCmp:
	;epilogo
	pop rbp
	ret



; char* strClone(char* a[rdi])
strClone:
	;prologo
	push rbp
	mov rbp, rsp
	push r12
	push r13

	mov r12, rdi

	call strLen
	mov r13, rax

	mov rdi, rax ; pasamos por parametro la long del array
	add rdi, 1	; le sumamos 1
	call malloc
	mov r9, rax ; r9 = pos de memoria del nuevo string

	add r13, 1
	mov rcx, r13 ; carga la cantidad de iteraciones a hacer al contador de vueltas
	.cycle:     ; etiqueta a donde retorna el ciclo que itera sobre arr
		mov r8b, byte[r12] ; r8b = char actual
		mov byte[r9], r8b
		add r9, 1
		add r12, 1
	loop .cycle ; decrementa ecx y si es distinto de 0 salta a .cycle

	;epilogo
	pop r13
	pop r12
	pop rbp
	ret

; void strDelete(char* a)
strDelete:
	;prologo
	push rbp
	mov rbp, rsp
	
	call free

	;epilogo
	pop rbp
	ret

; void strPrint(char* a[rdi], FILE* pFile[rsi])
strPrint:
	;prologo
	push rbp
	mov rbp, rsp
	push r12
	push r13

	mov r12, rdi
	mov r13, rsi

	mov bl, byte[rdi] ; bl = primer char
	cmp bl, 0
	jnz imprimir
	mov rdi, null_msg

imprimir:
	call fprintf                ; Llamar a la función fprintf

	;epilogo
	pop r13
	pop r12
	pop rbp
	ret

; uint32_t strLen(char* a[rdi])
strLen:
	;prologo
	push rbp
	mov rbp, rsp

	mov eax, 0

	ciclo:
	mov bl, byte[rdi] ; bl = char actual
	cmp bl, 0
	jz terminar
	add eax, 1
	add rdi, 1
	jmp ciclo

terminar:
	;epilogo
	pop rbp
	ret

