    .section .data
pos:
    .asciz " "

    .section .text
    .global user_move
user_move:
    mov $0, %rax
    mov $1, %rdi
    lea pos, %rsi
    mov $1, %rdx
    syscall

    lea pos, %r9
    mov (%r9), %r10
    add $-48, %r10

    cmpq $0, %r10
    jl retry
    cmpq $8, %r10
    jg retry
    jmp end

retry:
    jmp user_move

end:
    mov %r10, %rax
    ret
