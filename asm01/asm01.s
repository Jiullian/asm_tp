global _start

section .data
    value: dd '1337'

section .text

_start:

    mov rax,1               ;Appel système pour écrire
    mov rdi,1               ;Sortie standard = STDOUT
    mov rsi,value           ;Passe l'adresse de Value
    mov rdx,5               ;Spécifie la taille du buffer
    syscall

    mov rax,60
    mov rdi,0               ;Retourne 0
    syscall