.globl main

main:

    li   a7, 56              # syscall: openat
    li   a0, -100            # AT_FDCWD
    la   a1, filename
    li   a2, 0               # O_RDONLY
    li   a3, 0
    ecall
    mv   s0, a0              # s0 = fd
    li   a7, 62              # syscall: lseek
    mv   a0, s0
    li   a1, 0
    li   a2, 2               # SEEK_END
    ecall
    mv   s1, a0              # s1 = file size
    addi s2, x0, 0           # left = 0
    addi s3, s1, -1          # right = size-1

loop:
    bge  s2, s3, is_palindrome
    li   a7, 62
    mv   a0, s0
    mv   a1, s2
    li   a2, 0               # SEEK_SET
    ecall
    li   a7, 63              # read
    mv   a0, s0
    la   a1, buf1
    li   a2, 1
    ecall
    lb   t0, 0(buf1)
    li   a7, 62
    mv   a0, s0
    mv   a1, s3
    li   a2, 0
    ecall
    li   a7, 63
    mv   a0, s0
    la   a1, buf2
    li   a2, 1
    ecall
    lb   t1, 0(buf2)
    # compare the begining and end
    bne  t0, t1, not_palindrome
    addi s2, s2, 1
    addi s3, s3, -1
    j    loop

is_palindrome:
    la   a0, yes_str
    call printf
    j    exit

not_palindrome:
    la   a0, no_str
    call printf

exit:
    li   a0, 0
    ret


.section .rodata
filename: .string "input.txt"
yes_str:  .string "Yes\n"
no_str:   .string "No\n"

.section .bss
buf1: .space 1
buf2: .space 1