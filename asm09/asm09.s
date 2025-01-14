section .bss
    output  resb 32

section .text
    global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jne exit_program

    mov rbx, [rsp + 8]
    mov rsi, [rsp + 16]

convert_param:
    xor rax, rax
    xor rcx, rcx

convert_loop:
    mov bl, [rsi + rcx]
    cmp bl, 0
    je conversion_done
    cmp bl, '0'
    jb invalid_input
    cmp bl, '9'
    ja invalid_input
    sub bl, '0'
    movzx rbx, bl
    imul rax, rax, 10
    add  rax, rbx
    inc  rcx
    jmp  convert_loop

conversion_done:
    cmp rax, 0
    jne hex_conversion
    mov byte [output], '0'
    mov rsi, output
    mov rdx, 1
    jmp print_hex

hex_conversion:
    lea rdi, [output + 31]
    mov byte [rdi], 0
    dec rdi
    xor rcx, rcx

hex_loop:
    mov rbx, 16
    mov rdx, 0
    div rbx

    cmp rdx, 9
    jle hex_digit_num
    add rdx, 'A' - 10
    jmp write_hex

hex_digit_num:
    add rdx, '0'

write_hex:
    mov [rdi], dl
    dec rdi
    inc rcx
    cmp rax, 0
    jne hex_loop

    inc rdi
    mov rsi, rdi
    mov rdx, rcx

print_hex:
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

invalid_input:
    jmp display_error

display_error:
    mov rax, 60
    mov rdi, 1
    syscall

exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall
