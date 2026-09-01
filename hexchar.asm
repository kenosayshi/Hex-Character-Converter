#i had to write this many comments or i was gonna get lost lolol :3
#i use arch btw
.section .bss
buf:
    .space 1
.section .data
#newline: .ascii "\n"
.section .text
.global _start
.intel_syntax noprefix

_start:
    mov rcx, [rsp]      # load argc
    cmp rcx, 2          # there should only be 1 argument (the input and the program name)
    jne err
    mov rbx, [rsp+16]           # rbx = pointer to argv[1]
    cmp byte ptr [rbx+1], 0     # errors out if theres more than one char in arg1
    jne err
    mov bl, byte ptr [rbx]      # bl = character
    #A-F at 01000000-01000110
    #a-f at 01100000-01100110
    #0-9 at 00110000-00111001
    shl bl, 3           # 0-9 now at 10000000-11001000, a-f now matching A-F at 00001000-00110000
    cmp bl, 0x40        # 128 = 0x40 = 01000000, 0-9 are greater, a-f are less
    jbe carry           # send a-f to carry
    shl bl, 1           # sends 0 at 00000000, 9 at 10010000
    call print
    jmp exit

carry:
#    cmp bl, 96         # errors out for g-i trust (couldn't get this to work D:)
#    jnbe err
    mov bh, bl          # temporarily move into b higher
    mov bl, 16           # put in 16 to print 1, after >> 4 this = 1
    call print
    sub bh, 8           # lines up a-f with 0-9, went from 00000000-00101000 to now at 00000000-00101000
    shl bh, 1           # just to match 0-9, f now at 00000000-10010000
    mov bl, bh          # move back into bl for print second digit
    call print
    jmp exit

print:                  # prints anything in bl
    shr bl, 4           # counteract what we did before to line up a-f with A-F and 0-5, might split and move above sub in line 36 to exchange for dec
    cmp bl, 9
    ja err              # all numbers we're concerned with are between 00000000-00001010
    xor bl, 48          # effectively adds 48 because 16 and 32 bits are empty, sends 0x0 to ascii 0
    mov byte ptr [rip + buf], bl
                        # load bl into the buffer
    lea rsi, [rip + buf]# relative buffer
    mov rax, 1          # write syscall
    mov rdx, 1          # print 1 byte
    mov rdi, 1          # write to stdout
    syscall             # print char
    mov rax, 1
    mov rdi, 1
    ret

exit:
#    lea rsi, [newline]  # print new line
#    mov rdx, 1
#    syscall
    mov rax, 60
    xor rdi, rdi
    syscall

err:
    movzx rdi, bl       # error code is mismatched number
    mov rax, 60
    syscall
