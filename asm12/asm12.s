global _start

section .bss
buffer resb 32

section .text

_start:
    mov rax, [rsp]
    cmp rax, 2                ; Vérifie qu'il y a un argument fourni
    jl _pas_arguments

    ; Charger le premier argument (la chaîne à inverser)
    mov rdi, [rsp+16]
    call reverse_string       ; Appelle la fonction pour inverser le mot

    ; Afficher le résultat
    mov rsi, rax              ; rax contient l'adresse de la chaîne inversée
    mov rdx, 32               ; Longueur maximale à afficher
    mov rax, 1
    mov rdi, 1
    syscall

    ; Quitter le programme
    mov rax, 60
    xor rdi, rdi
    syscall

reverse_string:
    ; Trouver la longueur de la chaîne
    xor rcx, rcx

.find_length:
    mov dl, byte [rdi+rcx]
    cmp dl, 0
    je .reverse
    inc rcx
    jmp .find_length

.reverse:
    mov rsi, rdi              ; rsi pointe sur la chaîne originale
    lea rdi, [buffer + 31]    ; rdi pointe à la fin du tampon
    xor rax, rax

.reverse_loop:
    cmp rcx, 0
    je .done
    dec rcx
    mov dl, byte [rsi+rcx]    ; Charger le caractère courant en partant de la fin
    mov [rdi], dl            ; Stocker dans le tampon inversé
    dec rdi                  ; Déplacer le pointeur du tampon
    jmp .reverse_loop

.done:
    mov byte [rdi], 10        ; Ajouter un saut de ligne
    lea rax, [rdi]            ; Retourner l'adresse du début de la chaîne inversée
    ret

_pas_arguments:
    mov rax, 60
    mov rdi, 1
    syscall
