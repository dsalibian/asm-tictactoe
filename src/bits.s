    .section .text

    .global get_bit
    # rdi: bitboard
    # rsi: k
get_bit:
    mov %rdi, %rax      # rax: bitboard
    mov %rsi, %rcx      # must move k to %cl for shr
    shr %cl, %rax       # bitboard >>= k
    and $1, %rax        # bitboard &= 1 

    ret


    .global set_bit
    # rdi: bitboard
    # rsi: k
set_bit:
    mov %rdi, %rax
    mov %rsi, %rcx
    mov $1, %r10
    shl %cl, %r10
    or %r10, %rax
    ret
