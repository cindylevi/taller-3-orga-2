
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
		mov r9, qword[rdi] ; r9 = pos de memoria del complex_item actual
		add r9, 24
		add eax, dword[r9];sumamos a eax el valor z del complex actual
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
		mov r9, qword[rdi] ; r9 = pos de memoria del complex_item actual
		add r9, 20
		add eax, dword[r9];sumamos a eax el valor z del complex actual
		add rdi, 8;aumentamos la pos de memoria al siguiente item del array
	loop .cycle ; decrementa ecx y si es distinto de 0 salta a .cycle

	;epilogo
	pop rbp
	ret


;extern void product_9_f(uint32_t * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[?], f1[?], x2[?], f2[?], x3[?], f3[?], x4[?], f4[?]
;	, x5[?], f5[?], x6[?], f6[?], x7[?], f7[?], x8[?], f8[?],
;	, x9[?], f9[?]
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
	cvtss2sd xmm8, xmm8
	cvtss2sd xmm9, xmm9

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5
	mulsd xmm0, xmm6
	mulsd xmm0, xmm7
	mulsd xmm0, xmm8
	mulsd xmm0, xmm9
	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	; COMPLETAR

	; epilogo
	pop rbp
	ret

