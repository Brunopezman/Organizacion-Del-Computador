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

%macro mScanf 0
    sub     rsp,8
    call    sscanf
    add     rsp,8
%endmacro

%macro mPuts 1
    mov     rdi,%1
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro

%macro mAtoi 1
    mov     rdi,%1
    call    atoi
    mov     [%1],rax
%endmacro

global main
extern puts
extern gets
extern printf
extern sscanf
extern atoi

section     .data
    msj1        db      "Ingrese numero: ",0
    msj2        db      "Ingrese exponente: ",0
    msj3        db      "El resultado del elevar %li al exponente %li es: %li",10,0

section     .bss
    numero      resq    1
    exponente   resq    1
    resultado   resq    1
    cociente    resq    1

section     .text
main:
; Pido por pantalla el primer numero
    mPuts   msj1
    mGets   numero
; Lo convierto a entero
    mAtoi   numero
; Pido por pantalla el segundo numero
    mPuts   msj2
    mGets   exponente
; Lo convierto a entero
    mAtoi   exponente
; Inicializo los registros rbx y r12 para el calculo del exponente
    mov     rbx,1
    mov     r12,qword[exponente]
; Comparo si el exponente es negativo o positivo para saber en que caso estoy
    cmp     r12,0
    je      exponenteCero
    jl      exponenteNegativo
    jg      exponentePositivo

exponenteCero:
; Si el exponente es cero, el resultado es 1
    mov     qword[resultado],1
    jmp     fin
exponenteNegativo:
; Convierto el exponente en positivo para poder realizar los calculos mas facilmente
    neg     r12
    jmp     calculoExponente
exponentePositivo:
    jmp     calculoExponente

calculoExponente:
; Multiplico el numero por si mismo hasta llegar a la cantidad de veces que indica el exponente
    imul    rbx,qword[numero]
    dec     r12
    cmp     r12,0
    jne     calculoExponente
    mov     [resultado], rbx
; Si el exponente era negativo, divido 1 por el resultado obtenido
    cmp     qword[exponente], 0
    jge     fin
    mov     rax,1
    mov     rbx,[resultado]
    xor     rdx,rdx
    idiv    rbx
    mov     [resultado], rax

fin:
    mov     rdi,msj3
    mov     rsi,[numero]
    mov     rdx,[exponente]
    mov     rcx,[resultado]
    mPrintf

    ret