    .section .rodata
result_masks:
    .int 0b100100100
    .int 0b010010010
    .int 0b001001001
    .int 0b111000000
    .int 0b000111000
    .int 0b000000111
    .int 0b100010001
    .int 0b001010100
    .int 0b111111111

    .section .text
    .global eval
eval:
    push %rbx
    push %rbp

    mov $0, %rbx            # rbx: counter
    lea result_masks, %rbp  # rbp: result_masks address

loop:
    mov $0, %r10            # clear r10 upper bits             
    movl (%rbp), %r10d      # r10: result_masks[counter]

    mov %r10, %r11
    and x_bitboard, %r11
    cmpq %r11, %r10         # x_bitboard & mask == mask 
    jne endif_0

    mov $1, %rax            # return X_WIN
    jmp end

endif_0:
    mov %r10, %r11
    and o_bitboard, %r11
    cmpq %r11, %r10         # o_bitboard & mask == mask 
    jne endif_1

    mov $-1, %rax           # return O_WIN
    jmp end

endif_1:
    inc %rbx
    add $4, %rbp
    cmpq $8, %rbx
    jne loop

    mov $0, %r10      
    movl (%rbp), %r10d      # r10: result_masks[8]
    xor x_bitboard, %r10d
    xor o_bitboard, %r10d

    test %r10, %r10
    jnz endif_2

    mov $0, %rax            # return DRAW
    jmp end

endif_2:
    mov $2, %rax            # return NOT_GAMEOVER

end:
    pop %rbp
    pop %rbx
    ret
