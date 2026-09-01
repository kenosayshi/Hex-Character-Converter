# Hexadecimal character converter

This program takes a single character of hexadecimal and prints the corresponding base 10 character using bitshifts. 
Build with:
``` shell
as hexchar.asm -o hexchar.o
gcc -o hexchar hexchar.o -nostdlib -static
```

left in comments to print a new line after each character. to enable, uncomment lines 7, 59, 60, and 61.

This program errors out if the input is more than one character or non-hex. 
