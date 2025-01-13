global _start

section .text

_start:
    mov rax,60
    mov rdi,0               ;Renvoyer 0
    syscall