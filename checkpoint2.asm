extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_simplified
global alternate_sum_8
global product_2_f
global alternate_sum_4_using_c

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4:
	;prologo
	push rbp
	mov rbp, rsp
	;recordar que si la pila estaba alineada a 16 al hacer la llamada
	;con el push de RIP como efecto del CALL queda alineada a 8
	sub rdi, rsi
	sub rdx, rcx
	add rdi, rdx
	mov rax, rdi
	;epilogo
	pop rbp
	ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4_using_c:
	;prologo33333333333333333333333333333333
	push rbp
	mov rbp, rsp
	;recordar que si la pila estaba alineada a 16 al hacer la llamada
	;con el push de RIP como efecto del CALL queda alineada a 8
	call restar_c
	push rax
	mov rdi, rdx
	mov rsi, rcx
	call restar_c
	pop rcx
	mov rdi, rcx
	mov rsi, rax

	call sumar_c

	;epilogo
	pop rbp
	ret



; uint32_t alternate_sum_4_simplified(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4_simplified:

	sub rdi, rsi
	sub rdx, rcx
	add rdi, rdx
	mov rax, rdi

	ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[rdi], x2[rsi], x3[rdx], x4[rcx], x5[r8], x6[r9], x7[pila], x8[pila]
alternate_sum_8:
	;prologo
	push rbp
	mov rbp, rsp
	push r12
	sub rsp,0x8
	;recordar que si la pila estaba alineada a 16 al hacer la llamada
	;con el push de RIP como efecto del CALL queda alineada a 8
	call alternate_sum_4_simplified
	mov r12, rax
	mov rdi, r8
	mov rsi, r9

	mov rdx, [rbp + 16]
	mov rcx, [rbp + 24]
	call alternate_sum_4_simplified
	add rax, r12

	;epilogo
	add rsp, 0x8
	pop r12
	pop rbp

	ret

; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[rdi], x1[rsi], f1[xmm0]
product_2_f:
; Hace la multiplicación x1 * f1 y el resultado se almacena en destination. Los dígitos decimales del resultado se eliminan mediante truncado
	;prologo
	push rbp
	mov rbp, rsp

	cvtsi2sd xmm1, rsi		;d=64 f/s=32 w=16 b=8   ;
	cvtss2sd xmm2, xmm0		;d=64 f/s=32 w=16 b=8   ;
	mulsd xmm1, xmm2
	cvttsd2si edx, xmm1
	mov dword [rdi], edx 

	;epilogo
	pop rbp
	ret

