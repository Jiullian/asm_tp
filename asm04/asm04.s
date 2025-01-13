global _start
section .data

section .bss
    input resb 11

section .text
_start:
    mov eax, 0             ; Lecture depuis l'entrée standard
    mov edi, 0             ; IEntrée standard = STDIN
    mov rsi, input         ; Pointe vers la variable 'input'
    mov edx, 11            ; ire 11 octets
    syscall                

    mov rdi, input         ; Pointe rdi vers le début de 'input'
    add rdi, 10            ; Déplace rdi pour pointer vers le 11e octet

_dernier:
    cmp byte [rdi], 0x30   ; Compare le caractère à '0' (0x30 en hexa)
    jb _verifier           
    cmp byte [rdi], 0x39   ; Compare le caractère à '9'
    ja _verifier           
    jmp _resultat          

_verifier:
    dec rdi                ; Décrémente rdi pour pointer vers le caractère précédent
    jmp _dernier           ; Boucle pour vérifier à nouveau le caractère

_resultat:
    movzx eax, byte [rdi]  ; Extrait le caractère actuel
    sub eax, '0'           ; Convertit le caractère ASCII en sa valeur numérique

    and eax, 1             ; Effectue un ET avec 1 pour déterminer si le nombre est impair
    jnz _impair

    mov rax, 60            ; Prépare l'appel système pour exit
    mov rdi, 0             ; Retourne 0
    syscall

_impair:
    mov rax, 60            ; Prépare l'appel système pour exit
    mov rdi, 1             ; Retourne 1
    syscall                
