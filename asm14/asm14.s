global _start

section .data
    message db "Hello Universe!", 10 ; Le message à écrire avec un saut de ligne (\n)
    msg_len equ $ - message            ; La longueur du message

section .bss
    buffer resb 32

section .text

_start:
    mov rax, [rsp]          ; Vérifie le nombre d'arguments
    cmp rax, 2
    jl _pas_arguments

    ; Charger le chemin du fichier (le premier argument après le nom de l'exécutable)
    mov rdi, [rsp+16]

    ; Ouvrir le fichier en mode écriture/création (syscall openat)
    xor rax, rax           ; Nettoyer rax
    mov rax, 257           ; syscall openat
    mov rdi, -100          ; AT_FDCWD pour le répertoire courant
    mov rsi, [rsp+16]      ; Adresse du chemin du fichier
    mov rdx, 577           ; O_CREAT | O_WRONLY
    mov r10, 644           ; Mode 0644 (rw-r--r--)
    syscall

    cmp rax, 0             ; Vérifie si l'ouverture a échoué
    js _error_exit

    mov rdi, rax           ; Sauvegarde du descripteur de fichier

    ; Écrire "Hello Universe!" dans le fichier
    mov rax, 1             ; syscall write
    mov rsi, message       ; Adresse du message
    mov rdx, msg_len       ; Taille du message
    syscall

    ; Fermer le fichier
    mov rax, 3             ; syscall close
    syscall

    ; Quitter avec succès
    mov rax, 60            ; syscall exit
    xor rdi, rdi           ; Code de retour 0
    syscall

_error_exit:
    mov rax, 60            ; syscall exit
    mov rdi, 1             ; Code de retour 1
    syscall

_pas_arguments:
    mov rax, 60            ; syscall exit
    mov rdi, 1             ; Code de retour 1
    syscall
