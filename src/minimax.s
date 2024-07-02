    .section .text
    .global minimax
minimax:
    call eval
    cmpq $2, %rax       # if eval != NOT_GAMEOVER, return eval
    je endif_0

    ret 

endif_0:
    push %rbp
    push %rbx

    movl to_move, %r10d
    testq %r10, %r10
    jz if_1

    mov $-1, %rbx
    jmp endif_1

if_1:
    mov $1, %rbx        # rbx: best eval

endif_1:
    mov $0, %rbp        # rbp: counter

loop:
    movl x_bitboard, %edi
    orl o_bitboard, %edi
    mov %rbp, %rsi      # if occupied position skip
    call get_bit
    test %rax, %rax
    jnz endloop
    
    push to_move
    push x_bitboard
    push o_bitboard
    push %rbx
    push %rbp

    mov %rbp, %rdi
    call make_move
    call minimax
  
    pop %rbp
    pop %rbx
    pop o_bitboard
    pop x_bitboard
    pop to_move

    mov %rbx, %rdi
    mov %rax, %rsi

    movl to_move, %r10d
    testq %r10, %r10    # call min/max depending on to move
    jz if_2

    call max
    jmp endif_2

if_2:
    call min
    
endif_2:
    mov %rax, %rbx

endloop:
    inc %rbp
    cmpq $9, %rbp
    jne loop

    mov %rbx, %rax
    pop %rbx
    pop %rbp
    ret
