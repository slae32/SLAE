#!/usr/bin/python
 
# custom NOT/ROL/XOR encoder 
# Author SLAE – 926 for SecurityTube Linux Assembly Expert course
 
rol = lambda val, r_bits, max_bits: \
    (val << r_bits%max_bits) & (2**max_bits-1) | \
    ((val & (2**max_bits-1)) >> (max_bits-(r_bits%max_bits)))
	
shellcode = (
"\x31\xc0\x50\x68\x2f\x2f\x6c\x73\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"
)

encoded = ""
encoded2 = ""

xor_byte = 0xaa

for x in bytearray(shellcode) :

	w = ~x # not encode
	
	y = rol(w, 6, 8) # rotate left with 6
	z = y^xor_byte # xor with xor_byte
	
	if str('%02x' % z) == "00":
		print "NULL in shellcode"
		sys.exit()

	encoded += '\\x'
        encoded += '%02x' % z

        encoded2 += '0x'
        encoded2 += '%02x,' % z
	
print encoded

print encoded2

print 'Length: %d' % len(bytearray(shellcode))
