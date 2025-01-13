global _start

section .data
    number dd '1337',0

section .bss
    input resb 3

section .text

_start:
    mov eax, 0              ;appel système pour lire
    mov edi, 0              ;entrée standard = STDIN
    mov rsi, input          ;place l'adresse de la variable input
    mov edx, 3              ;taille de l'input
    syscall


    mov al, [input]         ;compare les valeurs de input avec 1337
    cmp al, 0x34            ;si la valeur est différente, saute à _not_equal
    jne _not_equal

    mov al, [input + 1]     ;compare les valeurs de input avec 1337
    cmp al, 0x32            ;si la valeur est différente, saute à _not_equal
    jne _not_equal

    mov al, [input + 2]     ;compare les valeurs de input avec 1337
    cmp al, 0x0A            ;si la valeur est différente, saute à _not_equal
    jne _not_equal


    mov rax, 1              ;appel système pour écrire
    mov rdi, 1              ;sortie standard = STDOUT
    mov rsi, number         ;place l'adresse de la variable number
    mov rdx, 4              ;taille de number
    syscall


    mov rax, 60             ;appel système pour quitter
    mov rdi, 0              ;retourne 0
    syscall

_not_equal:
    mov rax, 60
    mov rdi, 1
    syscall