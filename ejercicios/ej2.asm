%macro mGets 1
    mov     rdi,%1
    sub     rsp,8
    call    gets
    add     rsp,8
%endmacro

%macro mPuts 1
    mov     rdi,%1
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro

%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

global main
extern puts
extern gets
extern printf

section     .data
    msjNombre      db      "nombre: ",0
    msjApellido    db      "apellido: ",0
    msjPadron      db      "padron: ",0
    msjEdad        db      "Edad: ",0
    msjImprimir    db      "El alumno %s %s de padron numero %s tiene %s anios",0

section     .bss
    nombre      resb 100
    apellido    resb 100
    padron      resb 100
    edad        resb 100

section     .text
main:
    mPuts   msjNombre
    mGets   nombre

    mPuts   msjApellido
    mGets   apellido

    mPuts   msjPadron
    mGets   padron

    mPuts   msjEdad
    mGets   edad

    mov     rdi,msjImprimir
    mov     rsi,nombre
    mov     rdx,apellido
    mov     rcx,padron
    mov     r8,edad
    mPrintf 

    ret
