
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global complex_sum_z
global packed_complex_sum_z
global product_9_f

;########### DEFINICION DE FUNCIONES
;extern uint32_t complex_sum_z(complex_item *arr[rdi], uint32_t arr_length[rsi]);
;registros: arr[rdi], arr_length[rsi]
complex_sum_z:
	;prologo
	push rbp
	mov rbp, rsp
	mov eax, 0x0 ;seteamos a eax en cero para usarlo de sumador

	mov ecx, esi ; carga la cantidad de iteraciones a hacer al contador de vueltas
	.cycle:     ; etiqueta a donde retorna el ciclo que itera sobre arr
		add rdi, 24 ; aumentamos la memoria hasta el valor z
		add eax, dword[rdi];sumamos a eax el valor z del complex actual
		add rdi, 8;aumentamos la pos de memoria al siguiente item del array
	loop .cycle ; decrementa ecx y si es distinto de 0 salta a .cycle

	;epilogo
	pop rbp
	ret

;extern uint32_t packed_complex_sum_z(packed_complex_item *arr, uint32_t arr_length);
;registros: arr[?], arr_length[?]
packed_complex_sum_z:
	;prologo
	push rbp
	mov rbp, rsp
	mov eax, 0x0 ;seteamos a eax en cero para usarlo de sumador

	mov ecx, esi ; carga la cantidad de iteraciones a hacer al contador de vueltas
	.cycle:     ; etiqueta a donde retorna el ciclo que itera sobre arr
		add rdi, 20 ; aumentamos la memoria hasta el valor z
		add eax, dword[rdi];sumamos a eax el valor z del complex actual
		add rdi, 4;aumentamos la pos de memoria al siguiente item del array
	loop .cycle ; decrementa ecx y si es distinto de 0 salta a .cycle

	;epilogo
	pop rbp
	ret

;extern void product_9_f(uint32_t * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[rsi], f1[xmm0], x2[rdx], f2[xmm1], x3[rcx], f3[xmm2], x4[r8], f4[xmm3]
;	, x5[r9], f5[xmm4], x6[[rbp + 40]], f6[xmm5], x7[[rbp + 32]], f7[xmm6], x8[[rbp + 24]], f8[xmm7],
;	, x9[[rbp + 16]], f9[[rbp + 48]]
product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

	;convertimos los flotantes de cada registro xmm en doubles
	cvtss2sd xmm0, xmm0
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm2, xmm2
	cvtss2sd xmm3, xmm3
	cvtss2sd xmm4, xmm4
	cvtss2sd xmm5, xmm5
	cvtss2sd xmm6, xmm6
	cvtss2sd xmm7, xmm7

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5
	mulsd xmm0, xmm6
	mulsd xmm0, xmm7

	; multiplicamos a los floats que estaban en la pila
	cvtss2sd xmm1, [rbp + 48]
	mulsd xmm0, xmm1

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	cvtsi2sd xmm1, esi
	cvtsi2sd xmm2, edx
	cvtsi2sd xmm3, ecx
	cvtsi2sd xmm4, r8d ; si no lo ponia como e (agarrar solo 32 bits) lo tomaba mal
	cvtsi2sd xmm5, r9d

	mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5

	; multiplicamos a los int32 que estaban en la pila
	cvtsi2sd xmm1, [rbp + 16]
	cvtsi2sd xmm2, [rbp + 24]
	cvtsi2sd xmm3, [rbp + 32]
	cvtsi2sd xmm4, [rbp + 40]
	mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4

	movsd [rdi], xmm0
	; epilogo
	pop rbp
	ret

