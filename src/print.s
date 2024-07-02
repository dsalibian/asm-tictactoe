    .section .data
char:
    .asciz " "

x_win_string:
    .asciz "\n X WINS\n"
o_win_string:
    .asciz "\n O WINS\n"
draw_string:
    .asciz "\n DRAW\n"
badmove_string:
    .asciz "BAD MOVE\n"

    .section .text
    # print current state of board
    .global print_bitboard
print_bitboard:
    push %rbx
    push %rbp

    mov $0, %rbx        # rbx: counter
    mov $3, %rbp        # rbp: 3, for div
loop:
    mov %rbx, %rdi
    call remainder
    test %rax, %rax     # counter % 3 == 0 ?
    jnz endif_0

    call print_newline

endif_0:
    mov x_bitboard, %rdi    # rdi: x_bitboard
    mov %rbx, %rsi          # rsi: counter
    call get_bit
    test %rax, %rax
    jz endif_1 

    call print_x
    jmp endif

endif_1:
    mov o_bitboard, %rdi    # rdi: o_bitboard
    mov %rbx, %rsi          # rsi: counter
    call get_bit
    test %rax, %rax
    jz endif_2 

    call print_o
    jmp endif 

endif_2:
    call print_dot

endif:
    inc %rbx    
    cmpq $9, %rbx
    jne loop 

    call print_newline 

    pop %rbp
    pop %rbx
    ret



    .global print_char
    # rdi: char to be printed
print_char:
    mov %rdi, char
    mov $1, %rax    
    mov $1, %rdi
    lea char, %rsi
    mov $1, %rdx
    syscall
    ret

print_x:
    mov $88, %rdi
    call print_char
    ret

print_o:
    mov $79, %rdi
    call print_char
    ret

print_dot:
    mov $46, %rdi
    call print_char
    ret

print_newline:
    mov $10, %rdi
    call print_char
    ret

    # rdi: numerator
remainder:
    mov $0, %rdx        # set upper bits to 0
    mov %rdi, %rax      # set lower bits to arg
    mov $3, %r10        # set denominator to 3
    div %r10
    mov %rdx, %rax      # return remainder

    ret



    .global print_result
    # rdi: result
print_result:
    mov $1, %r10
    cmpq %rdi, %r10
    je print_x_win

    mov $-1, %r10
    cmpq %rdi, %r10
    je print_o_win

    lea draw_string, %rsi
    mov $7, %rdx
    jmp end

print_x_win:
    lea o_win_string, %rsi
    mov $9, %rdx
    jmp end

print_o_win:
    lea o_win_string, %rsi
    mov $10, %rdx
    jmp end

end:
    mov $1, %rax
    mov $0, %rdi
    syscall

    ret
