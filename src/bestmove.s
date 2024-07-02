    .section .text
    .global best_move
best_move:
    push %rbp
    push %rbx
    push %r12

    movl to_move, %r10d
    testq %r10, %r10    # check tomove to set best eval
    jz if_1

    mov $-1, %rbx
    jmp endif_1

if_1:
    mov $1, %rbx        # rbx: best eval

endif_1:
    mov $0, %rbp        # rbp: counter
    mov $0, %r12        # r12: best_move

loop:
    movl x_bitboard, %edi
    orl o_bitboard, %edi
    mov %rbp, %rsi      # if square is not empty then continue
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
    testq %r10, %r10    # check tomove to decide if bestmove should be set
    jz if_2

    cmpq %rbx, %rax     # call min/max depending on tomove
    jle endif_2
    mov %rbp, %r12
    call max

if_2:
    cmpq %rbx, %rax
    jge endif_2
    mov %rbp, %r12
    call min
    
endif_2:
    mov %rax, %rbx  

endloop:
    inc %rbp
    cmpq $9, %rbp
    jne loop

    mov %r12, %rax
    pop %r12
    pop %rbx
    pop %rbp
    ret
