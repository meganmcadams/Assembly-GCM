.386
.model flat,c
.stack  4096

; include C libraries
includelib      msvcrtd
includelib      oldnames
includelib      legacy_stdio_definitions.lib    ;for scanf, printf, ...

.data
	prompt1  db "Enter a number: ", 0
	prompt2	db	"Enter another number: ", 0
	prompt3 db "GCD: ", 0
	fmt		db "%i", 0
	num1	sdword ?
	num2	sdword ?
	result sdword ?

.code
	extrn   printf:near
	extrn   scanf:near
	extrn exit:near
	extrn atoi:near
	extrn sscanf:near

public  main
main    proc

	push    eax
	push    ebx
	push    ecx

	; num1 input
		push    offset prompt1
		call    printf

		; get input with scanf
		push	offset num1
		push	offset fmt
		call	scanf

	; num2 input
		push    offset prompt2
		call    printf

		; get input with scanf
		push	offset num2
		push	offset fmt
		call	scanf
		
		mov eax, [num1]
		mov ebx, [num2]

	; get min
	cmp eax, ebx
	jl aLess
	jg aGreater
	je aGreater

	aLess:
		mov result, eax
		jmp gcdLoop
	aGreater:
		mov result, ebx
		jmp gcdLoop

	gcdLoop:
		cmp result, 0 ; if result less than 0, break
		jl nextInstr

		mov num1, eax ; store eax in num1
		mov num2, ebx ; store ebx in num2

		mov edx, 0
		mov ebx, 0
		mov eax, [num1]
		mov ecx, result
		div ecx

		cmp edx, 0 ; compare remainder with 0
		jne notEqual ; if not equal to 0, jump to notEqual
		
		mov edx, 0
		mov ebx, 0
		mov eax, [num2]
		mov ecx, result
		div ecx

		cmp edx, 0 ; compare remainder with 0
		je nextInstr ; if equal to 0, jump to nextInstr

		notEqual:
		; restore num1 and num2
		mov eax, [num1]
		mov ebx, [num2]
		sub result, 1
		jmp gcdLoop

	nextInstr:
		
		push offset prompt3
		call printf

		add result, '0' ; convert
		push offset result
		call printf

		push 0			
		call exit

main    endp

end
