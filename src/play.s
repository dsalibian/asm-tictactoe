    .section .data
    .global x_bitboard
    .global o_bitboard
    .global to_move
x_bitboard:
    .int 0
o_bitboard:
    .int 0
to_move:
    .int 1

    .section .text
    .global play_loop
play_loop:
    movl to_move, %r10d
    test %r10d, %r10d       # if users turn get user move, otherwise make best move
    jz if

    call print_bitboard
    call user_move
    mov %rax, %rdi
    call make_move
    jmp endif

if:
    call best_move
    mov %rax, %rdi
    call make_move

endif:
    call eval
    cmpq $2, %rax       # continue while eval == NOT_GAMEOVER
    je play_loop
    
    push %rax
    call print_bitboard
    pop %rax
    mov %rax, %rdi
    call print_result
    ret
