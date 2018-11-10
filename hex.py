# Generate code for EEPROM burner.

pos = 32768
for hex in open("hex.txt"):
	hex = hex.strip()
	print "write(\"" + bin(pos)[3:].zfill(15) + "\", \"" + bin(int(hex, 16))[2:].zfill(8) + "\");"
	pos += 1

