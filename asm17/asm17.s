section .bss
    input resb 256  ; endroit pour stocker l'entrée utilisateur (256 max)

section .text
    global _start

_start:
    ; Vérifier s'il y a au moins 2 arguments
    mov rdi, [rsp]         ; Charger le nombre d'arguments (argc)
    cmp rdi, 2             ; Vérifier qu'il y a au moins 2 arguments (programme + décalage)
    jl .error

    ; Récupérer le deuxième argument pour l'indice de César
    mov rsi, [rsp + 16]    ; Charger l'adresse du deuxième argument
    movzx rdi, byte [rsi]  ; Charger le premier caractère de l'argument
    sub rdi, '0'           ; Convertir ASCII en valeur numérique
    cmp rdi, 0
    jl .error              ; Si le décalage est négatif, erreur
    cmp rdi, 9
    jg .error              ; Si le décalage est supérieur à 9, erreur
    mov r8b, dil           ; Stocker le décalage dans r8b (8 bits)

    ; Lecture de la chaîne
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 256           ; Taille max de la chaîne à lire
    syscall

    ; Charger la taille lue dans rcx pour parcourir la chaîne
    mov rcx, rax
    dec rcx                ; Ignorer le \n

    xor rbx, rbx           ; Index (RBX) initialisé à 0

.loop:
    cmp rbx, rcx
    jge .print

    ; Charger le caractère actuel
    mov al, [input + rbx]

    ; Vérifier si c'est une lettre minuscule
    cmp al, 'a'
    jl .check_upper         ; Si en dessous de 'a', vérifier majuscules
    cmp al, 'z'
    jg .next                ; Si au-dessus de 'z', passer au suivant

    ; Ajouter le décalage pour les minuscules
    add al, r8b
    cmp al, 'z'
    jle .store              ; Si inférieur ou égal à 'z', stocker
    sub al, 26              ; Revenir au début des minuscules

    jmp .store

.check_upper:
    ; Vérifier si c'est une lettre majuscule
    cmp al, 'A'
    jl .next                ; Si en dessous de 'A', passer au suivant
    cmp al, 'Z'
    jg .next                ; Si au-dessus de 'Z', passer au suivant

    ; Ajouter le décalage pour les majuscules
    add al, r8b
    cmp al, 'Z'
    jle .store              ; Si inférieur ou égal à 'Z', stocker
    sub al, 26              ; Revenir au début des majuscules

.store:
    ; Stocker le caractère chiffré
    mov [input + rbx], al

.next:
    ; Incrémenter l'index
    inc rbx
    jmp .loop              ; Recommencer la boucle

.print:
    ; Afficher la chaîne chiffrée
    mov rax, 1
    mov rdi, 1
    mov rsi, input
    mov rdx, rcx
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

.error:
    ; Si l'argument est invalide, quitter avec une erreur
    mov rax, 60
    mov rdi, 1
    syscall
