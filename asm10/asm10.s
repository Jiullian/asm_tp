global _start

section .bss
buffer resb 32

section .text

_start:
    mov rax, [rsp]
    cmp rax, 4                ; Vérifie qu'il y a au moins 3 arguments
    jl _pas_arguments

    ; Charger le premier argument
    mov rdi, [rsp+16]
    call atoi
    mov r8, rax               ; r8 = premier argument

    ; Charger le deuxième argument
    mov rdi, [rsp+24]
    call atoi
    mov r9, rax               ; r9 = deuxième argument

    ; Charger le troisième argument
    mov rdi, [rsp+32]
    call atoi
    mov r10, rax              ; r10 = troisième argument

    ; Comparer r8 et r9
    cmp r8, r9
    jge .compare_r8_r10       ; Si r8 >= r9, comparer r8 avec r10
    mov r8, r9                ; Sinon, r8 = r9

.compare_r8_r10:
    cmp r8, r10
    jge .result_ready         ; Si r8 >= r10, r8 est le plus grand
    mov r8, r10               ; Sinon, r8 = r10

.result_ready:
    ; Convertir le résultat en chaîne de caractères
    mov rdi, r8
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

atoi:
    xor rax, rax
    xor rcx, rcx
    xor rdx, rdx

    mov dl, [rdi]
    cmp dl, '-'
    jne .parse_loop
    inc rdi
    mov rcx, 1

.parse_loop:
    mov dl, [rdi]
    cmp dl, 0
    je .done
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rdi
    jmp .parse_loop

.done:
    cmp rcx, 1
    jne .end
    neg rax

.end:
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

_pas_arguments:
    mov rax, 60
    mov rdi, 1
    syscall
