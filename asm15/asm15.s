global _start

section .data
    elf_magic db 0x7F, 'E', 'L', 'F'    ; Les 4 premiers octets d'un fichier ELF
    ei_class db 2                      ; Classe ELF (2 pour 64 bits)

section .bss
    buffer resb 16                     ; Tampon pour lire les premiers octets

section .text

_start:
    mov rax, [rsp]        ; argc est stocké à l'adresse rsp
    cmp rax, 2            ; vérifie si argc == 2 (programme + fichier)
    jne _error_exit

    mov rsi, [rsp + 16]   ; argv[1]

    ; appel système open(filename, O_RDONLY)
    mov rax, 2
    mov rdi, rsi
    xor rsi, rsi          ; O_RDONLY
    syscall

    ; vérifie si l'ouverture a réussi
    test rax, rax
    js _error_exit

    mov rdi, rax          ; fd (file descriptor)

    ; appel système read(fd, buffer, 16)
    mov rax, 0
    mov rsi, buffer
    mov rdx, 16           ; Taille à lire
    syscall

    ; vérifie si la lecture a réussi
    test rax, rax
    js _error_exit

    ; Vérifie les 4 premiers octets pour ELF magic
    mov rsi, buffer
    lea rdi, [rel elf_magic]  ; Utilisation de l'adresse relative
    mov rcx, 4                ; 4 octets à comparer

check_magic:
    mov al, [rsi]
    cmp al, [rdi]
    jne _not_elf
    inc rsi
    inc rdi
    loop check_magic

    ; Vérifie si c'est un ELF 64 bits (ei_class)
    mov al, [buffer + 4]
    lea rdi, [rel ei_class]
    cmp al, byte [rdi]
    jne _not_elf

    ; Retourne 0 (fichier ELF 64 bits)
    xor rdi, rdi          ; Code de retour 0
    jmp _exit

_not_elf:
    mov rdi, 1            ; Code de retour 1
    jmp _exit

_error_exit:
    mov rdi, 1            ; Code de retour 1

_exit:
    mov rax, 60           ; syscall exit
    syscall
