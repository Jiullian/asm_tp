global _start

section .data
    number db '1337', 0x0A

section .text

_start:
    mov rdi, [rsp]              ; argc
    cmp rdi, 1                  ; argc == 1
    je no_args                  

    mov rsi, [rsp + 16]         ; argv[1]

    mov al, [rsi]               ; argv[1][0]
    cmp al, 0x34                ; 4
    jne not_42

    mov al, [rsi + 1]           ; argv[1][1]
    cmp al, 0x32                ; 2
    jne not_42

    mov al, [rsi + 2]           ; argv[1][2]
    cmp al, 0x00                ; \0
    jne not_42

    mov rax, 1                  ; appel système pour écrire
    mov rdi, 1                  ; sortie standard = STDOUT
    mov rsi, number             ; adresse de number
    mov rdx, 5                  ;taille de number
    syscall

    mov rax, 60                 ;appel système pour terminer le programme
    mov rdi, 0                  ; retourne 0
    syscall

not_42:
    mov rax, 60                 ;appel système pour terminer le programme
    mov rdi, 1                  ; retourne 1
    syscall

no_args:
    mov rax, 60                 ;appel système pour terminer le programme
    mov rdi, 1                  ; retourne 1
    syscall