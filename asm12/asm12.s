global _start

section .bss
buffer resb 32

section .text

_start:
    mov rax, [rsp]          ; Vérifie le nombre d'arguments
    cmp rax, 2
    jl _pas_arguments

    ; Charger le premier argument (la chaîne à inverser)
    mov rdi, [rsp+16]
    call reverse_string     ; Appeler la fonction pour inverser la chaîne

    ; Afficher le résultat
    mov rsi, rax            ; rax contient l'adresse de la chaîne inversée
    mov rdx, 32             ; Longueur maximale à afficher
    mov rax, 1              ; syscall write
    mov rdi, 1              ; File descriptor (stdout)
    syscall

    ; Quitter le programme
    mov rax, 60             ; syscall exit
    xor rdi, rdi
    syscall

reverse_string:
    ; Trouver la longueur de la chaîne
    xor rcx, rcx

.find_length:
    mov dl, byte [rdi+rcx]
    cmp dl, 0               ; Vérifie la fin de la chaîne
    je .reverse
    inc rcx
    jmp .find_length

.reverse:
    mov rsi, rdi            ; rsi pointe sur la chaîne originale
    lea rdi, [buffer]       ; rdi pointe sur le début du tampon
    xor rax, rax

.reverse_loop:
    cmp rcx, 0
    je .finalize
    dec rcx
    mov dl, byte [rsi+rcx]  ; Charger le caractère courant depuis la fin
    mov [rdi+rax], dl       ; Stocker dans le tampon
    inc rax                 ; Déplacer l'index du tampon
    jmp .reverse_loop

.finalize:
    mov byte [rdi+rax], 10  ; Ajouter un saut de ligne à la fin
    mov byte [rdi+rax+1], 0 ; Terminer la chaîne avec un caractère nul
    lea rax, [rdi]          ; Retourner l'adresse du tampon
    ret

_end:
    mov rax, 60             ; syscall exit
    mov rdi, 0
    syscall