global _start
section .data

section .bss
    input resb 11

section .text
_start:
    mov eax, 0             ; Lecture depuis l'entrée standard
    mov edi, 0             ; STDIN
    mov rsi, input         ; Pointe vers la variable 'input'
    mov edx, 11            ; Lire 11 octets
    syscall                

    mov rdi, input         ; Pointe rdi vers le début de 'input'
    add rdi, 10            ; Déplace rdi pour pointer vers le 11e octet

_dernier:
    ; --- AJOUTER LE TEST POUR A ---
    cmp byte [rdi], 'A'   ; Compare avec la lettre 'A'
    je _lettreA           ; Si égal, on saute pour quitter avec code 2

    cmp byte [rdi], 0x30   ; Compare le caractère à '0' (0x30)
    jb _verifier           ; Si en-dessous de '0', on continue à décrémenter
    cmp byte [rdi], 0x39   ; Compare le caractère à '9' (0x39)
    ja _verifier           ; Si au-dessus de '9', on continue
    jmp _resultat          ; Sinon, on a trouvé un chiffre

_verifier:
    dec rdi                ; On décrémente rdi pour pointer vers le caractère précédent
    jmp _dernier           ; Boucle jusqu'à trouver un chiffre ou 'A'

_lettreA:
    ; --- CODE DE SORTIE POUR LA LETTRE A ---
    mov rax, 60            ; syscall: exit
    mov rdi, 2             ; retourne 2
    syscall

_resultat:
    movzx eax, byte [rdi]  ; Extrait le caractère actuel
    sub eax, '0'           ; Convertit le caractère ASCII en valeur numérique

    and eax, 1             ; Test si le chiffre est impair (bit de poids faible)
    jnz _impair

    ; Si le chiffre est pair
    mov rax, 60
    mov rdi, 0
    syscall

_impair:
    ; Si le chiffre est impair
    mov rax, 60
    mov rdi, 1
    syscall
