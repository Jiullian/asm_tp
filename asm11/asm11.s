global _start

section .bss
buffer resb 32

section .text

_start:
    mov rax, [rsp]
    cmp rax, 2                ; Vérifie qu'il y a un argument fourni
    jl _pas_arguments

    ; Charger le premier argument (la chaîne à analyser)
    mov rdi, [rsp+16]
    call count_vowels         ; Appelle la fonction pour compter les voyelles

    ; Convertir le résultat en chaîne de caractères
    mov rdi, rax
    call itoa

    ; Afficher le résultat
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    ; Quitter le programme
    mov rax, 60
    xor rdi, rdi
    syscall

count_vowels:
    xor rax, rax              ; rax = compteur de voyelles
    xor rcx, rcx              ; rcx = index

.count_loop:
    mov dl, byte [rdi+rcx]    ; Charger le caractère courant
    cmp dl, 0                 ; Vérifier la fin de la chaîne
    je .done

    ; Vérifier si le caractère est une voyelle (minuscule ou majuscule)
    cmp dl, 'a'
    je .is_vowel
    cmp dl, 'e'
    je .is_vowel
    cmp dl, 'i'
    je .is_vowel
    cmp dl, 'o'
    je .is_vowel
    cmp dl, 'u'
    je .is_vowel
    cmp dl, 'y'
    je .is_vowel
    cmp dl, 'A'
    je .is_vowel
    cmp dl, 'E'
    je .is_vowel
    cmp dl, 'I'
    je .is_vowel
    cmp dl, 'O'
    je .is_vowel
    cmp dl, 'U'
    je .is_vowel
    cmp dl, 'Y'
    je .is_vowel
    jmp .not_vowel

.is_vowel:
    inc rax                   ; Incrémenter le compteur si voyelle

.not_vowel:
    inc rcx                   ; Passer au caractère suivant
    jmp .count_loop

.done:
    ret

itoa:
    mov rax, rdi
    mov rbx, buffer + 31
    mov byte [rbx], 10
    dec rbx

    xor rcx, rcx
    test rax, rax
    jge .positive
    neg rax
    mov rcx, 1

.positive:

.itoa_loop:
    xor rdx, rdx
    mov r8, 10
    div r8
    add rdx, '0'
    mov [rbx], dl
    dec rbx
    test rax, rax
    jne .itoa_loop

    cmp rcx, 1
    jne .done
    mov byte [rbx], '-'
    dec rbx

.done:
    lea rax, [rbx+1]
    ret

_end:
    mov rax, 60
    mov rdi, 0
    syscall