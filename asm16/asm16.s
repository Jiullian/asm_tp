section .data
    old_pattern dd 0x37333331    ;1337 en little endian
    new_pattern dd 0x4B433448    ;H4CK en little endian
    buffer_size equ 8196

section .bss
    buffer resb buffer_size

section .text
    global _start

_start:
    ;verif des arguments
    mov rax, [rsp]
    cmp rax, 2
    jl invalid_arguments


    ;on recup le nom du fichier (argv1)
    mov rsi, [rsp + 16]

    ;on ouvre le fichier en mode lecture/écriture
    mov rax, 2;sys_open
    mov rdi, rsi  ;file name
    mov rsi, 2
    syscall
    cmp rax, 0
    ;save du descripteur de fichier dans rbx
    mov rbx, rax

    ;on lie le fichier
    mov rax, 0
    mov rdi, rbx
    mov rsi, buffer
    mov rdx, buffer_size
    syscall

    ;si on arrive pas a lire le fichier -> on exit avec error1
    cmp rax, 0
    jle error          
    mov rcx, rax ;nombre de bytes lu

    ;index pour la recherche
    xor r10, r10

search_loop:
    ;on vérifie le nombre de byte restant a comparer, si il y en a moin de quatre (pour éviter de dépasser le buffer) -> error1 
    mov rax, rcx
    sub rax, r10
    cmp rax, 4
    jb error

    ;charger 4 bytes depuis le tampon à l'index actuel
    mov eax, [buffer + r10]

    ;on compare avec 1337, si c'est différent on jmp au nexbyte
    cmp eax, [old_pattern]
    jne next_byte


    ;si on a bien trouvé 1337 (son little endian) on le remplace 
    ;lseek pour se positionner à l'offset
    mov rax, 8
    mov rdi, rbx ;descripteur de fichier
    mov rsi, r10 ;offset = index
    mov rdx, 0;seel set
    syscall

    ;si echec -> error1
    cmp rax, 0
    jl error

    ;ecriture de H4CK dans l'offset (la version little endian)
    mov rax, 1
    mov rdi, rbx
    lea rsi, [new_pattern]
    mov rdx, 4
    syscall
    ;si echec -> error1
    cmp rax, 4
    jne error 

    ;on ferme le fichier une fois fini
    jmp close_file

next_byte:
    inc r10
    jmp search_loop

close_file:
    mov rax, 3
    mov rdi, rbx
    syscall
    cmp rax, 0
    jl error

    mov rax, 60
    xor rdi, rdi
    syscall

error:
    mov rdi, rax
    neg rdi
    mov rax, 60
    syscall

invalid_arguments:
    mov rax, 60
    mov rdi, 1
    syscall