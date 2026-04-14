.globl main

main:
    addi sp, sp, -64
    sd   ra, 56(sp)
    sd   s0, 48(sp)
    sd   s1, 40(sp)
    sd   s2, 32(sp)
    sd   s3, 24(sp)
    sd   s4, 16(sp)
    sd   s5,  8(sp)
    sd   s6,  0(sp)
    addi s0, a0, -1      # s0 = n = argc - 1
    mv   s1, a1          # s1 = argv
    blez s0, print_done  # n <= 0: nothing to do
    slli a0, s0, 3
    call malloc
    mv   s2, a0
    slli a0, s0, 3
    call malloc
    mv   s3, a0
    slli a0, s0, 3
    call malloc
    mv   s4, a0
    li   s5, 0           # stack top = 0 (empty)
    li   s6, 0

init_loop:
    bge  s6, s0, init_done
    slli t0, s6, 3
    add  t0, s3, t0
    li   t1, -1
    sd   t1, 0(t0)
    addi s6, s6, 1
    j    init_loop

init_done:
    li   s6, 0

parse_loop:
    bge  s6, s0, parse_done
    addi t0, s6, 1       # index s6+1 into argv
    slli t0, t0, 3
    add  t0, s1, t0
    ld   a0, 0(t0)       # argv[s6+1]
    call atoi
    slli t0, s6, 3
    add  t0, s2, t0
    sd   a0, 0(t0)       # arr[s6] = atoi(...)
    addi s6, s6, 1
    j    parse_loop

parse_done:
    addi s6, s0, -1      # i = n-1

algo_loop:
    blt  s6, x0, algo_done
    # t2 = arr[i]
    slli t0, s6, 3
    add  t0, s2, t0
    ld   t2, 0(t0)

    # while stack not empty && arr[stack.top()] <= arr[i]: pop
pop_loop:
    beq  s5, x0, pop_done
    addi t3, s5, -1          # top index
    slli t4, t3, 3
    add  t4, s4, t4
    ld   t5, 0(t4)           # t5 = stack.top() (an index)
    slli t6, t5, 3
    add  t6, s2, t6
    ld   t6, 0(t6)           # arr[stack.top()]
    bgt  t6, t2, pop_done    # arr[top] > arr[i] → stop
    addi s5, s5, -1          # pop
    j    pop_loop

pop_done:
    # if stack not empty: result[i] = stack.top()
    beq  s5, x0, do_push
    addi t3, s5, -1
    slli t4, t3, 3
    add  t4, s4, t4
    ld   t5, 0(t4)           # stack.top()
    slli t4, s6, 3
    add  t4, s3, t4
    sd   t5, 0(t4)           # result[i] = stack.top()

do_push:
    # stack.push(i)
    slli t0, s5, 3
    add  t0, s4, t0
    sd   s6, 0(t0)
    addi s5, s5, 1
    addi s6, s6, -1
    j    algo_loop

algo_done:
    li   s6, 0

print_loop:
    bge  s6, s0, print_done
    slli t0, s6, 3
    add  t0, s3, t0
    ld   s5, 0(t0)       # result[s6] (s5 reused; stack no longer needed)
    la   a0, fmt_d
    mv   a1, s5
    call printf
    addi t0, s6, 1
    blt  t0, s0, print_space
    la   a0, fmt_nl      # last element: print newline
    call printf
    j    print_next

print_space:
    la   a0, fmt_sp
    call printf

print_next:
    addi s6, s6, 1
    j    print_loop

print_done:
    li   a0, 0
    ld   ra, 56(sp)
    ld   s0, 48(sp)
    ld   s1, 40(sp)
    ld   s2, 32(sp)
    ld   s3, 24(sp)
    ld   s4, 16(sp)
    ld   s5,  8(sp)
    ld   s6,  0(sp)
    addi sp, sp, 64
    ret

.section .rodata
fmt_d:  .string "%ld"
fmt_sp: .string " "
fmt_nl: .string "\n"