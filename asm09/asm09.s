section .bss
    number  resb 10
    output  resb 33

section .text
    global _start

_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, number
    mov edx, 10
    int 0x80

    mov ecx, number
    xor eax, eax
    xor ebx, ebx

read_decimal:
    mov bl, [ecx]
    cmp bl, 10
    je convert_base
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc ecx
    jmp read_decimal

convert_base:
    mov ecx, 32
    lea edi, [output + 32]

loop_hex:
    xor edx, edx
    mov ebx, 16
    div ebx
    cmp edx, 9
    jle store_digit
    add edx, 55
    jmp write_digit

store_digit:
    add edx, '0'

write_digit:
    dec edi
    mov [edi], dl
    dec ecx
    test eax, eax
    jnz loop_hex

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    lea edx, [output + 32]
    sub edx, edi
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
