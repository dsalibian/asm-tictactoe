    .section .text
    .global make_move
    # rdi: pos
make_move:
    movl to_move, %r10d
    test %r10, %r10         # to_move ?
    jz else

    mov %rdi, %rsi
    mov x_bitboard, %rdi    # set bit at pos for correct board
    call set_bit
    mov %rax, x_bitboard
    jmp endif

else:
    mov %rdi, %rsi
    mov o_bitboard, %rdi
    call set_bit
    mov %rax, o_bitboard

endif:
    xorl $1, to_move        # flip tomove

    ret
