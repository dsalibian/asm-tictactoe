    .section .text
    .global main
main:
    call play_loop

    mov $60, %rax
    mov $0, %rdi 
    syscall
