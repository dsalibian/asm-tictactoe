    .section .text
    .global min
    # rdi: a
    # rsi: b
min:
    cmpq %rdi, %rsi
    jg if
    mov %rsi, %rax
    jmp endif

if:
    mov %rdi, %rax

endif:
    ret

    .global max
max:
    cmpq %rdi, %rsi
    jl if_0
    mov %rsi, %rax
    jmp endif_0

if_0:
    mov %rdi, %rax

endif_0:
    ret
