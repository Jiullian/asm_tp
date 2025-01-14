section .bss
    number   resb 10
    output   resb 33

section .text
    global _start

_start:
    mov rdi, [rsp]
    cmp rdi, 2 
    je _no_param_provided

    mov rax, 0
    mov rdi, 0
    mov rsi, number
    mov rdx, 10
    syscall

    mov rsi, number

    xor rax, rax
    xor rbx, rbx

read_decimal:
    mov bl, [rsi]
    cmp bl, 10
    je  convert_base
    sub bl, '0'
    imul rax, rax, 10
    add  rax, rbx
    inc  rsi
    jmp  read_decimal

convert_base:
    mov rcx, 32
    lea rdi, [output + 32]

loop_hex:
    xor rdx, rdx
    mov rbx, 16
    div rbx
    cmp rdx, 9
    jle store_digit
    add rdx, 55
    jmp write_digit

store_digit:
    add rdx, '0'

write_digit:
    dec rdi
    mov [rdi], dl
    dec rcx
    test rax, rax
    jnz loop_hex

    mov rax, 1
    mov rsi, rdi
    lea rdx, [output + 32]
    sub rdx, rdi
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

_no_param_provided:
    mov rax, 60
    xor rdi, 1
    syscall