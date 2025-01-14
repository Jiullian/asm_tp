global _start

section .bss
buffer resb 32

section .text

_start:
    mov rax, [rsp]          ; Vérifie le nombre d'arguments
    cmp rax, 2
    jl _pas_arguments

    ; Charger le premier argument (la chaîne à vérifier)
    mov rdi, [rsp+16]
    call reverse_string     ; Appeler la fonction pour inverser la chaîne

    ; Comparer la chaîne originale et inversée
    mov rsi, [rsp+16]       ; rsi pointe sur la chaîne originale
    lea rdi, [buffer]       ; rdi pointe sur la chaîne inversée
    call compare_strings    ; Appeler la fonction pour comparer les chaînes

    ; Quitter avec le code de retour approprié (0 si palindrome, 1 sinon)
    mov rax, 60             ; syscall exit
    mov rdi, rax            ; rax contient le résultat de compare_strings
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
    mov byte [rdi+rax], 0   ; Terminer la chaîne avec un caractère nul
    lea rax, [rdi]          ; Retourner l'adresse du tampon
    ret

compare_strings:
    ; Comparer deux chaînes caractère par caractère
    xor rcx, rcx

.compare_loop:
    mov al, byte [rsi+rcx]
    mov bl, byte [rdi+rcx]
    cmp al, bl
    jne .not_palindrome
    cmp al, 0               ; Vérifie la fin des deux chaînes
    je .is_palindrome
    inc rcx
    jmp .compare_loop

.is_palindrome:
    mov rax, 60             ; syscall exit
    mov rdi, 0
    syscall

.not_palindrome:
    mov rax, 60             ; syscall exit
    mov rdi, 1
    syscall
