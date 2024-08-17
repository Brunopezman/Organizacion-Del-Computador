global main
extern puts

section     .data
    msj     db      "Organizacion del computador",0

section     .text
main:
    mov     rdi,msj
    call    puts
    ret