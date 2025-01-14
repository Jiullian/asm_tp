section .bss
    output  resb 32          ; Réserve 32 octets pour la sortie

section .text
    global _start

_start:
    ; Récupération de argc
    mov rax, [rsp]            ; rax = argc
    cmp rax, 2
    je convert_hex            ; Si argc == 2, convertir en hexadécimal
    cmp rax, 3
    je check_b_flag           ; Si argc == 3, vérifier le flag -b
    jmp display_error         ; Sinon, afficher une erreur

check_b_flag:
    ; Récupération des arguments
    mov rbx, [rsp + 8]        ; rbx = argv0 (nom du programme)
    mov rcx, [rsp + 16]       ; rcx = argv1

    ; Vérification que argv1 est "-b"
    mov al, byte [rcx]
    cmp al, '-' 
    jne display_error

    mov al, byte [rcx + 1]
    cmp al, 'b'
    jne display_error

    mov al, byte [rcx + 2]
    cmp al, 0
    jne display_error

    ; Récupération du paramètre numérique
    mov rsi, [rsp + 24]        ; rsi = argv2
    mov r8, 1                  ; Flag binaire activé
    jmp convert_param

convert_hex:
    ; Récupération du paramètre numérique
    mov rsi, [rsp + 16]        ; rsi = argv1
    mov r8, 0                  ; Flag binaire désactivé (hexadécimal)
    jmp convert_param

convert_param:
    ; Conversion de la chaîne en nombre
    xor rax, rax               ; rax = 0 (accumulateur)
    xor rcx, rcx               ; rcx = 0 (index)

convert_loop:
    mov bl, [rsi + rcx]
    cmp bl, 0
    je conversion_done
    cmp bl, '0'
    jb invalid_input
    cmp bl, '9'
    ja invalid_input
    sub bl, '0'
    movzx rbx, bl
    imul rax, rax, 10
    add  rax, rbx
    inc  rcx
    jmp  convert_loop

conversion_done:
    cmp rax, 0
    je handle_zero             ; Si le nombre est 0, traiter séparément

    cmp r8, 1                  ; Vérifier si le flag binaire est activé
    je binary_conversion
    jmp hex_conversion

handle_zero:
    mov byte [output], '0'     ; Stocker '0' dans la sortie
    mov rsi, output
    mov rdx, 1
    jmp print_output

binary_conversion:
    lea rdi, [output + 31]     ; Pointeur vers la fin du buffer
    mov byte [rdi], 0          ; Terminateur nul
    dec rdi
    xor rcx, rcx               ; Réinitialiser l'index

binary_loop:
    mov rbx, 2
    xor rdx, rdx
    div rbx                    ; rax = rax / 2, rdx = rax % 2
    add dl, '0'                ; Convertir en caractère ASCII
    mov [rdi], dl
    dec rdi
    inc rcx
    cmp rax, 0
    jne binary_loop

    inc rdi                    ; Ajuster le pointeur
    mov rsi, rdi
    mov rdx, rcx
    jmp print_output

hex_conversion:
    lea rdi, [output + 31]     ; Pointeur vers la fin du buffer
    mov byte [rdi], 0          ; Terminateur nul
    dec rdi
    xor rcx, rcx               ; Réinitialiser l'index

hex_loop:
    mov rbx, 16
    mov rdx, 0
    div rbx                    ; rax = rax / 16, rdx = rax % 16

    cmp rdx, 9
    jle hex_digit_num
    add rdx, 'A' - 10          ; Convertir en caractère ASCII pour A-F
    jmp write_hex

hex_digit_num:
    add rdx, '0'                ; Convertir en caractère ASCII pour 0-9

write_hex:
    mov [rdi], dl
    dec rdi
    inc rcx
    cmp rax, 0
    jne hex_loop

    inc rdi                    ; Ajuster le pointeur
    mov rsi, rdi
    mov rdx, rcx
    jmp print_output

print_output:
    ; Appel système write
    mov rax, 1                 ; syscall: sys_write
    mov rdi, 1                 ; file descriptor: stdout
    syscall

    ; Appel système exit
    mov rax, 60                ; syscall: sys_exit
    xor rdi, rdi               ; exit code: 0
    syscall

invalid_input:
    jmp display_error

display_error:
    ; Appel système exit avec code d'erreur
    mov rax, 60                ; syscall: sys_exit
    mov rdi, 1                 ; exit code: 1
    syscall
