global _start

section .bss
buffer resb 32

section .text

_start:
    mov rdi, [rsp+16]
    call atoi
    mov r8, rax
    mov rdi, [rsp+24]
    call atoi
    add r8, rax
    mov rdi, r8
    call itoa
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall

atoi:
    xor rax, rax
    xor rcx, rcx
    xor rdx, rdx
atoi_loop:
    mov dl, [rdi]
    cmp dl, 0
    je atoi_done
    sub dl, '0'
    imul rax, 10
    add rax, rdx
    inc rdi
    jmp atoi_loop
atoi_done:
    ret

itoa:
    mov rax, rdi
    mov rbx, buffer + 31
    mov byte [rbx], 10
    dec rbx
    cmp rdi, 0
    jge itoa_positive
    neg rdi
itoa_positive:
    xor rcx, rcx
itoa_loop:
    xor rdx, rdx
    mov rcx, 10
    div rcx
    add rdx, '0'
    mov [rbx], dl
    dec rbx
    cmp rax, 0
    jne itoa_loop
    cmp rdi, 0
    jge itoa_done
    mov byte [rbx], '-'
    dec rbx
itoa_done:
    lea rax, [rbx+1]
    ret
