global _start

section .data
    message db "Hello Universe!", 10 ; Le message à écrire avec un saut de ligne (\n)
    msg_len equ $ - message            ; La longueur du message

section .bss
    buffer resb 32

section .text

_start:
    mov rax, [rsp]        ;argc est stocké à l'adresse rsp

    cmp rax, 2            ;vérifie si argc == 2 (programme + fichier)
    jne _error_exit

    mov rsi, [rsp + 16]

    ;appel système open(filename, O_WRONLY | O_CREAT | O_TRUNC, 0644)
    mov rax, 2
    mov rdi, rsi
    mov rsi, 0x241
    mov rdx, 0o644
    syscall

    ;vérifie si l'ouverture a réussi
    test rax, rax
    js _error_exit

    mov rdi, rax

    ;appel système write(fd, message, msg_len)
    mov rax, 1
    mov rsi, message
    mov rdx, msg_len
    syscall


    mov rax, 3
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

_error_exit:
    mov rax, 60            ; syscall exit
    mov rdi, 1             ; Code de retour 1
    syscall

_pas_arguments:
    mov rax, 60            ; syscall exit
    mov rdi, 1             ; Code de retour 1
    syscall
