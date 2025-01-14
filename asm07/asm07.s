global _start

section .data
    message db 'Entrez un nombre: ', 0xA
section .bss
    number resb 32

section .text

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, message            ;affiche le message
    mov rdx, 17
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, number             ;recupere le nombre
    mov rdx, 32
    syscall

    cmp byte [rsi], 'A'
    je _lettreA

    sub rax, 1
    mov rcx, rax
    lea rsi, [number]           ;pointe sur le nombre

    xor rdi, rdi

_decimal:
    xor rax, rax
    movzx rax, byte [rsi]       ;converti le caractere en nombre
    sub rax, '0'
    cmp rax, 10
    jae _prem
    imul rdi, rdi, 10           ;construit le nombre
    add rdi, rax
    inc rsi
    loop _decimal

_prem:
    cmp rdi, 2                  ;verifie si le nombre est premier
    jb _notpremier
    je _premier
    mov rcx, rdi                ;sauvegarde le nombre
    shr rcx, 1                  ;divise le nombre par 2
    mov rsi, 2                  ;initialise le diviseur

_test:
    mov rax, rdi                ;teste si le nombre est premier
    xor rdx, rdx
    div rsi                     ;divise le nombre par le diviseur
    cmp rdx, 0                  ;verifie si le reste est nul
    je _notpremier
    inc rsi                     ;incremente le diviseur
    cmp rsi, rcx                ;verifie si le diviseur est superieur a la moitie du nombre
    jbe _test

_premier:
    mov rax, 60 
    mov rdi, 0
    syscall

_notpremier:
    mov rax, 60
    mov rdi, 1
    syscall

_lettreA:
    mov rax, 60            ; syscall: exit
    mov rdi, 2             ; retourne 2
    syscall