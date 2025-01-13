section .data

section .bss

section .text
    global _start

_start:
    ; Récupérer argc (nombre d'arguments)
    ; Sur Linux x86_64 avec point d'entrée _start :
    ;   [rsp]   = argc (en 64 bits)
    ;   [rsp+8] = pointeur vers argv[0]
    ;   [rsp+16]= pointeur vers argv[1]
    ;   ...
    mov   rax, [rsp]      ; rax contient argc
    cmp   rax, 2
    jl    exitFailure     ; Si argc < 2, on sort avec code 1

    ; Récupérer argv[1]
    mov   rsi, [rsp + 16]
    test  rsi, rsi
    jz    exitFailure

    ; Calculer la longueur de argv[1] dans rax
    xor   rax, rax
.countLoop:
    cmp   byte [rsi + rax], 0
    je    .foundLen
    inc   rax
    jmp   .countLoop

.foundLen:
    mov   rdx, rax       ; rdx = longueur de la chaîne

    ; Appel système write(1, argv[1], length)
    mov   rax, 1         ; numéro du syscall write
    mov   rdi, 1         ; fd = 1 (stdout)
    syscall

    ; Sortir avec code 0
    mov   rax, 60        ; numéro du syscall exit
    xor   rdi, rdi       ; rdi = 0
    syscall

exitFailure:
    mov   rax, 60        ; syscall exit
    mov   rdi, 1         ; code de retour = 1
    syscall
