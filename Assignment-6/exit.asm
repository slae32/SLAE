; source http://shell-storm.org/shellcode/files/shellcode-623.php
; Modified by Author SLAE - 926 for SecurityTube Linux Assembly Expert course

global _start
_start:

xor eax, eax ; \x31\xc0
inc eax ; \x40
xor ebx, ebx ; \x31\xdb
int 0x80 ; \xcd\x80
