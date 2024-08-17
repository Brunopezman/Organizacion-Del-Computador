%macro mPuts 1
    mov rdi,%1
    sub rsp,8
    call puts
    add rsp,8
%endmacro

%macro mGets 1
    mov rdi,%1
    sub rsp,8
    call gets
    add rsp,8
%endmacro

%macro mPrintf 0
    sub rsp,8
    call printf
    add rsp,8
%endmacro

%macro mScanf 0
    sub rsp,8
    call sscanf
    add rsp,8
%endmacro

%macro mFPutsConSalto 3
    mov rdi, %1
    mov rsi, [%2]
    sub rsp,8
    call fputs
    add rsp,8   
    mov rdi, %3
    mov rsi, [%2]
    sub rsp,8
    call fputs
    add rsp,8
%endmacro

%macro mSprintf 3
    mov rdi, %1
    mov rsi, %2
    xor rdx, rdx
    mov dl, [%3]
    sub rsp,8
    call sprintf
    add rsp,8
%endmacro

%macro mFGets 2
    mov     rdi, %1
    mov     rsi, 3
    mov     rdx, [%2]
    sub     rsp, 8
    call    fgets
    add     rsp, 8
%endmacro

%macro PasajeAVariable 2
    xor     rdx, rdx
    mov     dl, [%1]
    mov     [%2], dl
%endmacro

%macro mScanfArchivo 3
    mov     rdi, %1
    mov     rsi, %2
    mov     rdx, %3
    mScanf
%endmacro

global main 
extern printf
extern gets
extern puts
extern sscanf
extern fopen
extern fclose
extern fputs
extern sprintf
extern fgets
extern memcpy
extern system


section .data
    ;Mensajes para utilizar con 'mPrintf' o 'mPuts'
    mensaje_inicio   db  10,"Bienvenido al juego de las ocas y el zorro!!",10,"En este juego, el zorro debe intentar comer 12 ocas sin que estas lo acorralen y lo dejen inmovil.",10,"Primero sera turno del usuario que use al zorro y luego el de las ocas. Si el zorro come una oca mantendra su turno.",10,"Buena suerte!",10,0
    mensaje_cargar  db  "Desea iniciar una partida nueva o cargar una ya existente? ('N' para nueva, 'C' para cargar una existente)",10,"Si elige cargar partida y no hay ninguna disponible para cargar, se iniciara una partida default (sin ninguna modificacion ni edicion en el tablero)",0
    mensaje_eleccion db  "Desea elegir un tablero? ('S' para si, 'N' para no)", 0
    mensaje_edicion  db  "Desea editar el tablero? ('S' para si, 'N' para no)", 0
    m_edicion_zorro  db  "Que caracter quiere que represente el zorro? ", 0
    m_edicion_oca    db  "Que caracter quiere que represente la oca? ", 0
    mensaje_tablero  db  "Elija el tablero que desea jugar:",10," Opcion 1 => Ocas en la parte alta",10," Opcion 2 => Ocas sobre la izquierda",10," Opcion 3 => Ocas sobre la derecha",10," Opcion 4 => Ocas en la parte baja",10,"Envie el numero de la opcion que desea elegir: ", 0
    mensaje_limpieza db  "Desea limpiar la pantalla luego de cada turno? ('S' para si, 'N' para no)", 0
    mensaje_zorro   db  "Turno del ZORRO!! Indica a que fila y columna se desea mover el mismo.",10,"(Recorda que se puede mover en cualquier sentido solo un bloque, a menos que estes comiendo una oca)",10,"Si quieres conocer los comandos posibles o ayuda, presione 'A'.", 0
    mensaje_ocas1   db  "Turno de las OCAS!! Indica a que fila y columna de la oca que desee mover.",10,"Si quieres conocer los comandos posibles o ayuda, presione 'A'.", 0
    mensaje_ocas2   db  "Ahora indique a que fila y columna desea moverla.",10,"Si quieres conocer los comandos posibles o ayuda, presione 'A'.", 0
    mensaje_salida  db  "Estas seguro que desea salir del juego? ('S' para si, 'N' para no)", 0
    mensaje_error   db  10, "Lo enviado no es valido, por favor intenta nuevamente",0
    ayuda_usuario   db  "Comandos posibles:",10," *Para mover al zorro: Indique la fila y columna a la que desea moverlo",10," *Para mover a las ocas: Indique la fila y columna de la oca que desea mover y luego la fila y columna a la que desea moverla",10," *Para salir del juego sin guardar la partida: Presione 'S'",10," *Para salir y guardar la partida: Presione 'G'",10," *Para ver editar elementos del tablero: Presione 'E'",10,0
    men_error_arch  db  "Error al abrir el archivo",0
    mensaje_est     db "ESTADISTICAS DEL ZORRO:",10," *Movimientos hacia adelante: %hhi",10," *Movimientos hacia atras: %hhi",10," *Movimientos hacia la derecha: %hhi",10," *Movimientos hacia la izquierda: %hhi",10," *Movimientos en diagonal: %hhi",10,0
    ocas_comidas   db  "Ocas comidas: %hhi",10,0
    ocas_comidasf  db  " *Cantidad de ocas comidas la partida: %hhi",10,"Gracias por jugar!",10,0
    gano_zorro     db  10,"El zorro ha ganado la partida!! Logro comer a 12 ocas.",10,0
    gano_ocas      db  10,"Las ocas han ganado la partida!! Han acorralado al zorro.",10,0
    salida_mensaje db  10,"Esta bien, recuerda para tu proxima partida que puedes guardarla y seguir en otro momento!!",10,0
    guardada_mensaje db 10,"La partida ha sido guardada con exito!! Esperamos ver como termina luego.",10,0
    ;Tableros posibles
    tablero1         db "  ooo    ooo  oooooooo-----oo--x--o  ---    ---  ", 0
    tablero2         db "  ooo    o--  ooo----ooo-x--ooo----  o--    ooo  ", 0
    tablero3         db "  ooo    --o  ----ooo--x-ooo----ooo  --o    ooo  ", 0
    tablero4         db "  ---    ---  o--x--oo-----oooooooo  ooo    ooo  ", 0
    ;Elementos del tablero
    oca             db  "o",0
    zorro           db  "x",0
    vacio           db  "-",0
    no_jugable      db  " ",0
    ;Variables que uso para la impresion de la matriz
    elemento         db  0
    contador_ite     db  7
    contador_fil     db  7
    formato         db  "%c ", 0
    salto           db  10, 0
    ;Variables para conocer estado del juego
    elecciones_inicio   db " ", 0
    estado_juego    db  0   ;0 jugando, 1 termino el juego 
    turno           db  "Z", 0
    fila_zorro      db  0
    columna_zorro   db  0
    fila_oca        db  0
    columna_oca     db  0
    fila_mov        db  0
    columna_mov     db  0
    extra           db  0    ;Se agrega por si el usuario envia algo de mas, asi se puede invalidar
    contador_ocas   db  0
    comio_oca       db  0
    ;Formato para los movimientos enviados por el usuario
    formato_mov     db  "%hhi %hhi %hhi",0
    ;Contadores para estadisticas finales 
    mov_adelante    db  0
    mov_atras       db  0
    mov_izquierda   db  0
    mov_derecha     db  0
    mov_diagonal    db  0
    ;Variables para archivos -> Guardar y cargar partida
    archivo         db  "partida.txt",0
    modo_guardar    db  "w",0
    modo_leer       db  "r",0
    aux_archivo     db  " ",0
    salto_archivo   db  0xA,0
    formato_pasaje  db  "%hhi",0
    ;Variable para la limpieza de pantalla
    clear           db  "clear",0
    eleccion_clear  db  " ",0

section .bss
    victoria            resb 1
    ;Tablero para juego
    tablero             resb 49
    aux                 resb 1
    ;Variable para la eleccion del tablero
    eleccion_tablero    resb 1
    ;Variables para la edicion de los elementos del tablero
    zorro_nuevo         resb 1
    oca_nuevo           resb 1
    ;Variables para el input de los movimientos
    input_mov           resb 5
    input_salir         resb 1
    input_pos_oca       resb 5
    ;Variable para el guardado y carga de la partida
    fileHandler         resb 8
    numero_string       resb 1
    caracter            resb 1
    de_donde            resb 1
    
section .text

;'main': Por donde inicia siempre el juego, se dan las preguntas al usuario de si quiere cargar una partida o no, edicion, eleccion de tablero, etc. Las rutinas internas son llamadas desde aqui,
; pero explicadas mas abajo.
main:
    mPuts   mensaje_inicio  
    sub     rsp,8
    call    CargarPartida
    add     rsp,8
    sub     rsp,8
    call    LimpiezaPantalla
    add     rsp,8
    cmp     byte[elecciones_inicio], "C"
    je      LoopJuego
    sub     rsp,8
    call    EleccionTablero
    add     rsp,8
    sub     rsp,8
    call    EdicionTablero
    add     rsp,8

;'LoopJUego': Iteracion de los turnos dentro del juego, haciendo mediante arutinas internas el chequeo de cuando este debe frenar, para eso se implementa el uso de 'estado_juego' como controlador
; para el corte del mismo
LoopJuego:
    sub     rsp,8
    call    Limpieza
    add     rsp,8
    cmp     byte[estado_juego], 0
    jne     Estadisticas
    sub     rsp,8
    call    ImprimirTablero
    add     rsp,8
    mov     rdi, ocas_comidas
    mov     rsi, [contador_ocas]
    mPrintf
    sub     rsp,8
    call    Movimientos
    add     rsp,8
    jmp     LoopJuego



;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;-----------------------------------RUTINAS INTERNAS----------------------------------
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------

;Rutina para ser llamada en cualquier rutina que necesite salir y volver al loop
VolverMain:
    ret

;-------------------------------------------------------------------------------------

;Rutinas que se encargan de poder limpiar la pantalla en caso de que el usuario lo desee. Se le pregunta si quiere hacerlo, y en caso de que la respuesta sea afirmativa, se limpia la pantalla
;luego de cada turno
LimpiezaPantalla:
    mPuts   mensaje_limpieza
    mGets   eleccion_clear
    ret

Limpieza:
    cmp     byte[eleccion_clear], "N"
    je      VolverMain
    mov     rdi, clear
    sub     rsp, 8
    call    system
    add     rsp, 8
    ret

;-------------------------------------------------------------------------------------
;Estas primeras rutinas estan relacionadas con la carga de partida en caso de que el usuario quiera hacerlo. Para esto se le pregunta, y en caso de una respuesta afirmativa, se procede en la
;carga de la ultima partida guardada en el archivo 'partida.txt'. En caso de que ninguna partida haya sido guardada antes, el archivo contendra una partida 'default', es decir que no tiene
;ediciones de los elementos ni cambios en el tablero o estadisticas.
CargarPartida:
    mPuts   mensaje_cargar
    mGets   elecciones_inicio
    cmp     byte[elecciones_inicio], "N"
    je      VolverMain
    cmp     byte[elecciones_inicio], "C"
    je      CargarArchivo
    mPuts   mensaje_error
    jmp     CargarPartida

CargarArchivo:
    mov     byte[de_donde], "C"
    sub     rsp,8
    call    AbrirArchivo
    add     rsp,8

LoopLeerTablero:
    ;Chequeo si ya se leyo todo el tablero
    cmp     rbx, 49 
    je      PasarVariables
    ;Leo el tablero en el archivo y lo paso a mis juego
    mFGets  caracter, fileHandler
    ;Paso el caracter al tablero
    xor     rdx, rdx
    mov     dl, byte[caracter]
    mov     [tablero + rbx], dl
    ;itero
    inc     rbx
    jmp     LoopLeerTablero

PasarVariables:
    mFGets          caracter, fileHandler
    PasajeAVariable caracter, turno
    mFGets          caracter, fileHandler
    mScanfArchivo   caracter, formato_pasaje, fila_zorro
    mFGets  caracter, fileHandler
    mScanfArchivo   caracter, formato_pasaje, columna_zorro
    mFGets  caracter, fileHandler
    PasajeAVariable caracter, oca
    mFGets  caracter, fileHandler
    PasajeAVariable caracter, zorro
    mFGets  caracter, fileHandler
    mScanfArchivo   caracter, formato_pasaje, mov_adelante
    mFGets  caracter, fileHandler
    mScanfArchivo   caracter, formato_pasaje, mov_atras
    mFGets  caracter, fileHandler
    mScanfArchivo   caracter, formato_pasaje, mov_derecha
    mFGets  caracter, fileHandler
    mScanfArchivo   caracter, formato_pasaje, mov_izquierda
    mFGets  caracter, fileHandler
    mScanfArchivo   caracter, formato_pasaje, mov_diagonal
    mFGets  caracter, fileHandler
    mScanfArchivo   caracter, formato_pasaje, contador_ocas
    ;Muestro el tablero que se cargo
    sub     rsp,8
    call    ImprimirTablero
    add     rsp,8
    mov     rdi, ocas_comidas
    mov     rsi, [contador_ocas]
    mPrintf
    ;Cierro el archivo
    mov     rdi, [fileHandler]
    sub     rsp,8
    call    fclose
    add     rsp, 8
    ret

;-------------------------------------------------------------------------------------

;En las siguientes rutinas se maneja la eleccion y edicion del tablero de juego. En caso de que el usuario quiera elegir un tablero, se le pregunta cual de los 4 posibles quiere, y se lo carga
;en el tablero de juego. En caso de que quiera editar el tablero, se le pregunta que caracter quiere que represente al zorro y a la oca, y luego se da con el inicio del juego. 
EleccionTablero:
    ;Pido al usuario si quiere elegir un tablero
    mPuts   mensaje_eleccion
    mGets   elecciones_inicio
    cmp     byte[elecciones_inicio], "N"
    je      Tablero1
    cmp     byte[elecciones_inicio], "S"
    je      OpcionesTablero
    mPuts   mensaje_error
    jmp     EleccionTablero

OpcionesTablero:
    mPuts   mensaje_tablero
    mGets   eleccion_tablero 
    cmp     byte[eleccion_tablero], "1"
    je      Tablero1
    cmp     byte[eleccion_tablero], "2"
    je      Tablero2
    cmp     byte[eleccion_tablero], "3"
    je      Tablero3
    cmp     byte[eleccion_tablero], "4"
    je      Tablero4
    mPuts   mensaje_error
    jmp     EleccionTablero

Tablero1:
    mov     rsi, tablero1
    mov     rdi, tablero
    mov     rcx, 49
    rep movsb
    mov     byte[fila_zorro], 5
    mov     byte[columna_zorro], 4
    jmp     ImprimirTablero

Tablero2:
    mov     rsi, tablero2
    mov     rdi, tablero
    mov     rcx, 49
    rep movsb
    mov     byte[fila_zorro], 4
    mov     byte[columna_zorro], 5
    jmp     ImprimirTablero

Tablero3:
    mov     rsi, tablero3
    mov     rdi, tablero
    mov     rcx, 49
    rep movsb
    mov     byte[fila_zorro], 4
    mov     byte[columna_zorro], 3
    jmp     ImprimirTablero

Tablero4:
    mov     rsi, tablero4
    mov     rdi, tablero
    mov     rcx, 49
    rep movsb
    mov     byte[fila_zorro], 3
    mov     byte[columna_zorro], 4
    jmp     ImprimirTablero

EdicionTablero:
    ;Pregunto si quiere editar el tablero
    mPuts   mensaje_edicion
    mGets   elecciones_inicio
    cmp     byte[elecciones_inicio], "N"
    je      VolverMain
    cmp     byte[elecciones_inicio], "S"
    je      EdicionZorro
    mPuts   mensaje_error
    jmp     EdicionTablero

EdicionZorro:
    ;Pido al usuario que caracter quiere que represente al zorro
    mPuts   m_edicion_zorro
    mGets   zorro_nuevo
    jmp     EdicionOca

EdicionOca:
    ;Pido al usuario que caracter quiere que represente a la oca
    mPuts   m_edicion_oca
    mGets   oca_nuevo
    xor     rbx,rbx
    xor     rcx,rcx
    jmp     CambiarTablero

CambiarTablero:
    cmp     rbx, 49
    je      CambiarVariables
    mov     cl, [tablero + rbx]
    cmp     cl, byte[zorro]
    je      CambiarZorro
    cmp     cl, byte[oca]
    je      CambiarOca
    inc     rbx
    jmp     CambiarTablero

CambiarZorro:
    mov     cl, byte[zorro_nuevo]
    mov     [tablero + rbx], cl
    inc     rbx
    jmp     CambiarTablero

CambiarOca:
    mov     cl, byte[oca_nuevo]
    mov     [tablero + rbx], cl
    inc     rbx
    jmp     CambiarTablero

CambiarVariables:
    mov     cl, byte[zorro_nuevo]
    mov     byte[zorro], cl
    mov     cl, byte[oca_nuevo]
    mov     byte[oca], cl
    ret
;------------------------------------------------------------------------------------------------

;Estas rutinas se encargan de mostrar por pantalla el tablero que se tiene acutalmente, para que el usuario pueda hacer un movimiento a consiencia. Se creo un loop para acortar el codigo
; y hacerlo mas entendible.
ImprimirTablero:
    ;Inicializo puntero para recorrer el tablero y registro que uso como guia
    xor     rbx,rbx
    xor     rdx,rdx
    mov     rdx,tablero
    jmp     LoopProximaFila
LoopProximaFila:
    ;Chequeo que todavia quede tablero por mostrar
    cmp     byte[contador_ite],0
    je      FinDeImpresion
    ;Guardo registros para no perderlos y mostrar el tablero correctamente
    xor     rbx,rbx
    jmp     LoopPrint
LoopPrint:
    ;Tomo un elemento del tablero
    mov     cl,  [rdx + rbx]
    mov     [elemento], cl
    ;Lo imprimo
    mov     [aux], rdx
    mov     rdi, formato
    mov     rsi, [elemento]
    mPrintf
    mov     rdx, [aux]
    ;Aumento registro para tomar el proximo elemento en la proxima iteracion
    add     rbx, 1
    ;Reduzco en 1 el contador de elementos a imprimir de la fila
    dec     byte[contador_fil]
    ;Chequeo si ya termine de imprimir la fila
    cmp     byte[contador_fil],0
    jne     LoopPrint
    ;Si llego aca, ya termine de imprimir la fila, imprimo un salto de linea
    mov     [aux], rdx
    mov     rdi, salto
    mPrintf
    mov     rdx, [aux]
    ;Reinicio el contador de elementos de la fila
    add     byte[contador_fil], 7
    ;Avanzo a la proxima fila de la matirz con el puntero y el registro de guia
    add     rdx, 7
    ;Itero
    dec     byte[contador_ite]
    jmp     LoopProximaFila

FinDeImpresion:
    ;Reinicio el contador de iteraciones para posible futura impresion del tablero
    mov     byte[contador_ite], 7
    ret

;-------------------------------------------------------------------------------------

;En estas rutinas se trata los movimientos de tanto el zorro como de las ocas. Son las mas largas ya que se debe tener en cuenta cada caso y validarlo, ya sea que el zorro se este por move 
;contra una pared por ejemplo, o si una oca puede realizar el movimiento enviado por el usuario siguiendo que solo puede hacer movimientos hacia adelante y los costados. Tambien, se hace el
;conteo de los movimientos del zorro y se hacen las validaciones del estado del juego, sabiendo asi si en el ultimo movimiento el zorro comio a la oca numero 12, o si las ocas acorralaron 
;al zorro.
Movimientos:
    ;Chequeo de quien es el turno
    cmp     byte[turno], "Z"
    je      MovimientoZorro
    jne     MovimientoOcas
    ret

MovimientoZorro:
    sub     rsp,8
    call    EstaAcorralado
    add     rsp,8
    cmp     byte[estado_juego], 1
    je      Finalizar
    ;Imprimo mensaje para avisar al usuario que es turno del zorro
    mPuts   mensaje_zorro
    ;Leo el movimiento del zorro
    mGets   input_mov
    ;Chequeo si el usuario quiere ayuda
    cmp     byte[input_mov], "A"
    je      AyudaUsuario
    ;Chequeo si el usuario quiere salir del juego
    cmp     byte[input_mov], "S"
    je      SalirPartida
    ;Chequeo si el usuario quiere guardar del juego
    cmp     byte[input_mov], "G"
    je      GuardarPartida
    ;Chequeo si el usuario quiere editar el tablero
    cmp     byte[input_mov], "E"
    je      EdicionZorro
    ;Parseo el movimiento del zorro
    mov     rdi, input_mov
    mov     rsi, formato_mov
    mov     rdx, fila_mov
    mov     rcx, columna_mov
    mov     r8, extra
    mScanf    
    ;Chequeo que lo enviado sea valido
    cmp     rax, 2
    jne     MensajeErrorMovimientos
    ;Chequeo que el movimiento sea valido
    mov     cl, [fila_mov]
    sub     cl, [fila_zorro]
    cmp     cl, 1
    jg      MensajeErrorMovimientos
    cmp     cl, -1
    jl      MensajeErrorMovimientos
    mov     dl, [columna_mov]
    sub     dl, [columna_zorro]
    cmp     dl, 1
    jg      MensajeErrorMovimientos
    cmp     dl, -1
    jl      MensajeErrorMovimientos
    ;Si llego aca, el movimiento es valido, chequeo que no este pisando una oca ni saliendose del tablero
    ;Limpio registros para calcular desplazamiento sin problemas
    xor     rcx, rcx
    xor     rdx, rdx
    ;Busco posicion del tablero a donde ira a parar el zorro
    mov     cl, [fila_mov]
    dec     cl
    imul    cx, 7
    mov     dl, [columna_mov]
    dec     dl
    add     cl, dl
    sub     dl, dl
    ;Chequeo si quiere comer una oca
    mov     dl, byte[tablero + rcx]
    cmp     dl, byte[oca]
    je      IntentaComerOca
    ;Si comio una oca, se puede quedar quieto, sino no
    cmp     byte[comio_oca], 1
    je      ChequeoHabiendoComido
    jne     ChequeoSinComer

ChequeoHabiendoComido:
    cmp     dl, byte[no_jugable]
    je      MensajeErrorMovimientos
    jmp     SigueZorro

ChequeoSinComer:
    cmp     dl, byte[vacio]
    jne     MensajeErrorMovimientos
    jmp     SigueZorro

SigueZorro:
    ;Reinicio el registro de ocas comidas para el proximo turno
    mov     byte[comio_oca], 0
    ;Si llego aca, todo esta en orden. Primero borro la posicion anterior del zorro del tablero
    ;Limpio registros para calcular desplazamiento sin problemas
    xor     rcx, rcx
    xor     rdx, rdx
    mov     cl, byte[fila_zorro]
    dec     cl
    imul    cx, 7
    mov     dl, byte[columna_zorro]
    dec     dl
    add     cl, dl
    sub     dl, dl
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Actualizo el tablero con la posicion nueva del zorro 
    xor     rcx, rcx
    xor     rdx, rdx
    mov     cl, byte[fila_mov]
    dec     cl
    imul    cx, 7
    mov     dl, byte[columna_mov]
    dec     dl
    add     cl, dl
    sub     dl, dl
    mov     dl, byte[zorro]
    mov     [tablero + rcx], dl
    ;Chequeo en que direccion se movio el zorro para contabilizarlo
    sub     rsp,8
    call    ContabilizarMovimiento
    add     rsp,8
    ;Actualizo la posicion del zorro en las variables
    mov     cl, [fila_mov]
    mov     [fila_zorro], cl
    mov     cl, [columna_mov]
    mov     [columna_zorro], cl
    ;Cambio el turno
    mov     byte[turno], "O"
FinMovimientoZorro:
    sub     rsp,8
    call    ChequeoSiTerminoElJuego
    add     rsp,8
    ret

EstaAcorralado:
    ;Para saber si el zorro esta acorralado, chequeo todas las posiciones a las que ese pueda mover
    ;Obtengo desplazamiento de la posicion del zorro en el tablero
    xor     rax, rax
    xor     rcx, rcx
    xor     rdx, rdx
    mov     cl, [fila_zorro]
    sub     cl, 1
    imul    cx, 7
    mov     dl, [columna_zorro]
    sub     dl, 1
    add     cl, dl
    sub     dl, dl
    
AcorraladoDerecha:
    ;Chequeo si puede moverse hacia la derecha o saltar a la derecha (desde la vista del usuario)
    mov     dl, cl
    cmp     byte[columna_zorro], 7
    je      AcorraladoIzquierda
    inc     dl
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    cmp     byte[columna_zorro], 6
    je      AcorraladoIzquierda
    inc     dl
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    xor     rax, rax
    xor     rdx, rdx
    
AcorraladoIzquierda:
    ;Chequeo si puede moverse hacia la izquierda o saltar a la izquierda (desde la vista del usuario)
    mov     dl, cl
    cmp     byte[columna_zorro], 0
    je      AcorraladoArriba
    dec     dl
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    cmp     byte[columna_zorro], 1
    je      AcorraladoArriba
    dec     dl
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    xor     rax, rax
    xor     rdx, rdx

AcorraladoArriba:
    ;Chequeo si puede moverse hacia arriba o saltar hacia arriba (desde la vista del usuario)
    mov     dl, cl
    cmp     byte[fila_zorro], 0
    je      AcorraladoAbajo
    sub     dl, 7
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    cmp     byte[fila_zorro], 1
    je      AcorraladoAbajo
    sub     dl, 7
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    xor     rax, rax
    xor     rdx, rdx  

AcorraladoAbajo:
    ;Chequeo si puede moverse hacia abajo o saltar hacia abajo (desde la vista del usuario)
    mov     dl, cl
    cmp     byte[fila_zorro], 7
    je      AcorraladoDiagonalArribaDerecha
    add     dl, 7
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    cmp     byte[fila_zorro], 6
    je      AcorraladoDiagonalArribaDerecha
    add     dl, 7
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    xor     rax, rax
    xor     rdx, rdx

AcorraladoDiagonalArribaDerecha:
    ;Chequeo si puede moverse en diagonal hacia arriba a la derecha o saltar en diagonal hacia arriba a la derecha (desde la vista del usuario)
    mov     dl, cl
    cmp     byte[fila_zorro], 0
    je      AcorraladoDiagonalArribaIzquierda
    cmp     byte[columna_zorro], 7
    je      AcorraladoDiagonalArribaIzquierda
    sub     dl, 6
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    cmp     byte[fila_zorro], 1
    je      AcorraladoDiagonalArribaIzquierda
    cmp     byte[columna_zorro], 6
    je      AcorraladoDiagonalArribaIzquierda
    sub     dl, 6
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    xor     rax, rax
    xor     rdx, rdx

AcorraladoDiagonalArribaIzquierda:
    ;Chequeo si puede moverse en diagonal hacia arriba a la izquierda o saltar en diagonal hacia arriba a la izquierda (desde la vista del usuario)
    mov     dl, cl
    cmp     byte[fila_zorro], 0
    je      AcorraladoDiagonalAbajoDerecha
    cmp     byte[columna_zorro], 0
    je      AcorraladoDiagonalAbajoDerecha
    sub     dl, 8
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    cmp     byte[fila_zorro], 1
    je      AcorraladoDiagonalAbajoDerecha
    cmp     byte[columna_zorro], 1
    je      AcorraladoDiagonalAbajoDerecha
    sub     dl, 8
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    xor     rax, rax
    xor     rdx, rdx
AcorraladoDiagonalAbajoDerecha:
    ;Chequeo si puede moverse en diagonal hacia abajo a la derecha o saltar en diagonal hacia abajo a la derecha (desde la vista del usuario)
    mov     dl, cl
    cmp     byte[fila_zorro], 7
    je      AcorraladoDiagonalAbajoIzquierda
    cmp     byte[columna_zorro], 7
    je      AcorraladoDiagonalAbajoIzquierda
    add     dl, 8
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    cmp     byte[fila_zorro], 6
    je      AcorraladoDiagonalAbajoIzquierda
    cmp     byte[columna_zorro], 6
    je      AcorraladoDiagonalAbajoIzquierda
    add     dl, 8
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    xor     rax, rax
    xor     rdx, rdx

AcorraladoDiagonalAbajoIzquierda:
    ;Chequeo si puede moverse en diagonal hacia abajo a la izquierda o saltar en diagonal hacia abajo a la izquierda (desde la vista del usuario)
    mov     dl, cl
    cmp     byte[fila_zorro], 7
    je      Acorralado
    cmp     byte[columna_zorro], 0
    je      Acorralado
    add     dl, 6
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    cmp     byte[fila_zorro], 6
    je      Acorralado
    cmp     byte[columna_zorro], 1
    je      Acorralado
    add     dl, 6
    mov     al, [tablero + rdx]
    cmp     al, byte[vacio]
    je      NoEstaAcorralado
    ;Si llego aca, el zorro esta acorralado
    jmp     Acorralado

Acorralado:
    ;Si llego aca, el zorro esta acorralado, fin del juego
    mov     byte[estado_juego], 1
    mov     byte[victoria], "O"
    ret

NoEstaAcorralado:
    ;Si llego aca, el zorro no esta acorralado
    ret

IntentaComerOca:
    ;Si indico una posicion del tablero con una oca, chequeo si puede comerla, es decir que hay un espacio vacio atras
    mov     cl, [fila_zorro]
    sub     cl, [fila_mov]
    cmp     cl, 0
    je      ComiendoEnHorizontal
    mov     dl, [columna_zorro]
    sub     dl, [columna_mov]
    cmp     dl, 0
    je      ComiendoEnVertical
    jmp     ComiendoEnDiagonal

ComiendoEnHorizontal:
    mov     dl, [columna_zorro]
    sub     dl, [columna_mov]
    cmp     dl, -1
    je      HorizontalUno
    cmp     dl, 1
    je      HorizontalDos
    
HorizontalUno:
    mov     dl, [columna_mov]
    mov     cl, [fila_mov]
    dec     cl
    imul    cx, 7
    add     cl, dl
    xor     rdx, rdx
    mov     dl, [tablero + rcx]
    cmp     dl, byte[vacio]
    je      ComerOcaHorizontalUno
    jmp     MensajeErrorMovimientos

HorizontalDos:
    mov     dl, [columna_mov]
    sub     dl, 2
    mov     cl, [fila_mov]
    dec     cl
    imul    cx, 7
    add     cl, dl
    xor     rdx, rdx
    mov     dl, [tablero + rcx]
    cmp     dl, byte[vacio]
    je      ComerOcaHorizontalDos
    jmp     MensajeErrorMovimientos

ComerOcaHorizontalUno:
    ;Muevo al zorro
    xor     rdx, rdx
    mov     dl, byte[zorro]
    mov     [tablero + rcx], dl
    ;Borro la oca
    xor     rdx, rdx
    dec     rcx
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Borro al zorro viejo
    xor     rdx, rdx
    dec     rcx
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Contaiblizo el movimiento
    sub     rsp,8
    call    ContabilizarMovimiento
    add     rsp,8
    ;Actualizo la posicion del zorro
    mov     cl, [fila_mov]
    mov     [fila_zorro], cl
    mov     cl, [columna_mov]
    inc     cl
    mov     [columna_zorro], cl
    ;Actualizo el contador de ocas comidas
    inc     byte[contador_ocas]
    ;Sigo en el mismo turno
    mov     byte[comio_oca], 1
    jmp     FinMovimientoZorro

ComerOcaHorizontalDos:
    ;Muevo al zorro
    xor     rdx, rdx
    mov     dl, byte[zorro]
    mov     [tablero + rcx], dl
    ;Borro la oca
    xor     rdx, rdx
    inc     rcx
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Borro al zorro viejo
    xor     rdx, rdx
    inc     rcx
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Contaiblizo el movimiento
    sub     rsp,8
    call    ContabilizarMovimiento
    add     rsp,8
    ;Actualizo la posicion del zorro
    mov     cl, [fila_mov]
    mov     [fila_zorro], cl
    mov     cl, [columna_mov]
    dec     cl
    mov     [columna_zorro], cl
    ;Actualizo el contador de ocas comidas
    inc     byte[contador_ocas]
    ;Sigo en el mismo turno
    mov     byte[comio_oca], 1
    jmp     FinMovimientoZorro

ComiendoEnVertical:
    mov     cl, [fila_zorro]
    sub     cl, [fila_mov]
    cmp     cl, -1
    je      VerticalUno
    cmp     cl, 1
    je      VerticalDos

VerticalUno:
    mov     cl, [fila_mov]
    imul    cx, 7
    mov     dl, [columna_mov]
    dec     dl
    add     cl, dl
    xor     rdx, rdx
    mov     dl, [tablero + rcx]
    cmp     dl, byte[vacio]
    je      ComerOcaVerticalUno
    jmp     MensajeErrorMovimientos

VerticalDos:
    mov     cl, [fila_mov]
    sub     cl, 2
    imul    cx, 7
    mov     dl, [columna_mov]
    dec     dl
    add     cl, dl
    xor     rdx, rdx
    mov     dl, [tablero + rcx]
    cmp     dl, byte[vacio]
    je      ComerOcaVerticalDos
    jmp     MensajeErrorMovimientos

ComerOcaVerticalUno:
    ;Muevo al zorro
    xor     rdx, rdx
    mov     dl, byte[zorro]
    mov     [tablero + rcx], dl
    ;Borro la oca
    xor     rdx, rdx
    sub     rcx, 7
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Borro al zorro viejo
    xor     rdx, rdx
    sub     rcx, 7
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Contaiblizo el movimiento
    sub     rsp,8
    call    ContabilizarMovimiento
    add     rsp,8
    ;Actualizo la posicion del zorro
    mov     cl, [fila_mov]
    inc     cl
    mov     [fila_zorro], cl
    mov     cl, [columna_mov]
    mov     [columna_zorro], cl
    ;Actualizo el contador de ocas comidas
    inc     byte[contador_ocas]
    ;Sigo en el mismo turno
    mov     byte[comio_oca], 1
    jmp     FinMovimientoZorro

ComerOcaVerticalDos:
    ;Muevo al zorro
    xor     rdx, rdx
    mov     dl, byte[zorro]
    mov     [tablero + rcx], dl
    ;Borro la oca
    xor     rdx, rdx
    add     rcx, 7
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Borro al zorro viejo
    xor     rdx, rdx
    add     rcx, 7
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Contaiblizo el movimiento
    sub     rsp,8
    call    ContabilizarMovimiento
    add     rsp,8
    ;Actualizo la posicion del zorro
    mov     cl, [fila_mov]
    dec     cl
    mov     [fila_zorro], cl
    mov     cl, [columna_mov]
    mov     [columna_zorro], cl
    ;Actualizo el contador de ocas comidas
    inc     byte[contador_ocas]
    ;Sigo en el mismo turno
    mov     byte[comio_oca], 1
    jmp     FinMovimientoZorro

ComiendoEnDiagonal:
    mov     cl, [fila_zorro]
    sub     cl, [fila_mov]
    cmp     cl, -1
    je      PosibleDiagonalUnoDos
    cmp     cl, 1
    je      PosibleDiagonalTresCuatro

PosibleDiagonalUnoDos:
    mov     cl, [columna_zorro]
    sub     cl, [columna_mov]
    cmp     cl, -1
    je      DiagonalUno
    cmp     cl, 1
    je      DiagonalDos

PosibleDiagonalTresCuatro:
    mov     cl, [columna_zorro]
    sub     cl, [columna_mov]
    cmp     cl, -1
    je      DiagonalTres
    cmp     cl, 1
    je      DiagonalCuatro

DiagonalUno:
    mov     cl, [fila_mov]
    imul    cx, 7
    mov     dl, [columna_mov]
    add     cl, dl
    xor     rdx, rdx
    mov     dl, [tablero + rcx]
    cmp     dl, byte[vacio]
    je      ComerOcaDiagonalUno
    jmp     MensajeErrorMovimientos

DiagonalDos:
    mov     cl, [fila_mov]
    imul    cx, 7
    mov     dl, [columna_mov]
    sub     dl, 2
    add     cl, dl
    xor     rdx, rdx
    mov     dl, [tablero + rcx]
    cmp     dl, byte[vacio]
    je      ComerOcaDiagonalDos
    jmp     MensajeErrorMovimientos

DiagonalTres:
    mov     cl, [fila_mov]
    sub     cl, 2
    imul    cx, 7
    mov     dl, [columna_mov]
    add     cl, dl
    xor     rdx, rdx
    mov     dl, [tablero + rcx]
    cmp     dl, byte[vacio]
    je      ComerOcaDiagonalTres
    jmp     MensajeErrorMovimientos

DiagonalCuatro:
    mov     cl, [fila_mov]
    sub     cl, 2
    imul    cx, 7
    mov     dl, [columna_mov]
    sub     dl, 2
    add     cl, dl
    xor     rdx, rdx
    mov     dl, [tablero + rcx]
    cmp     dl, byte[vacio]
    je      ComerOcaDiagonalCuatro
    jmp     MensajeErrorMovimientos
    
ComerOcaDiagonalUno:
    ;Muevo al zorro
    xor     rdx, rdx
    mov     dl, byte[zorro]
    mov     [tablero + rcx], dl
    ;Borro la oca
    xor     rdx, rdx
    sub     rcx, 8
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Borro al zorro viejo
    xor     rdx, rdx
    sub     rcx, 8
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Contaiblizo el movimiento
    sub     rsp,8
    call    ContabilizarMovimiento
    add     rsp,8
    ;Actualizo la posicion del zorro
    mov     cl, [fila_mov]
    inc     cl
    mov     [fila_zorro], cl
    mov     dl, [columna_mov]
    inc     dl
    mov     [columna_zorro], dl
    ;Actualizo el contador de ocas comidas
    inc     byte[contador_ocas]
    ;Sigo en el mismo turno
    mov     byte[comio_oca], 1
    jmp     FinMovimientoZorro

ComerOcaDiagonalDos:
    ;Muevo al zorro
    xor     rdx, rdx
    mov     dl, byte[zorro]
    mov     [tablero + rcx], dl
    ;Borro la oca
    xor     rdx, rdx
    sub     rcx, 6
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Borro al zorro viejo
    xor     rdx, rdx
    sub     rcx, 6
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Contaiblizo el movimiento
    sub     rsp,8
    call    ContabilizarMovimiento
    add     rsp,8
    ;Actualizo la posicion del zorro
    mov     cl, [fila_mov]
    inc     cl
    mov     [fila_zorro], cl
    mov     dl, [columna_mov]
    dec     dl
    mov     [columna_zorro], dl
    ;Actualizo el contador de ocas comidas
    inc     byte[contador_ocas]
    ;Sigo en el mismo turno
    mov     byte[comio_oca], 1
    jmp     FinMovimientoZorro

ComerOcaDiagonalTres:
    ;Muevo al zorro
    xor     rdx, rdx
    mov     dl, byte[zorro]
    mov     [tablero + rcx], dl
    ;Borro la oca
    xor     rdx, rdx
    add     rcx, 6
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Borro al zorro viejo
    xor     rdx, rdx
    add     rcx, 6
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Contaiblizo el movimiento
    sub     rsp,8
    call    ContabilizarMovimiento
    add     rsp,8
    ;Actualizo la posicion del zorro
    mov     cl, [fila_mov]
    dec     cl
    mov     [fila_zorro], cl
    mov     dl, [columna_mov]
    inc     dl
    mov     [columna_zorro], dl
    ;Actualizo el contador de ocas comidas
    inc     byte[contador_ocas]
    ;Sigo en el mismo turno
    mov     byte[comio_oca], 1
    jmp     FinMovimientoZorro

ComerOcaDiagonalCuatro:
    ;Muevo al zorro
    xor     rdx, rdx
    mov     dl, byte[zorro]
    mov     [tablero + rcx], dl
    ;Borro la oca
    xor     rdx, rdx
    add     rcx, 8
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Borro al zorro viejo
    xor     rdx, rdx
    add     rcx, 8
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Contaiblizo el movimiento
    sub     rsp,8
    call    ContabilizarMovimiento
    add     rsp,8
    ;Actualizo la posicion del zorro
    mov     cl, [fila_mov]
    dec     cl
    mov     [fila_zorro], cl
    mov     dl, [columna_mov]
    dec     dl
    mov     [columna_zorro], dl
    ;Actualizo el contador de ocas comidas
    inc     byte[contador_ocas]
    ;Sigo en el mismo turno
    mov     byte[comio_oca], 1
    jmp     FinMovimientoZorro

ChequeoSiTerminoElJuego:
    cmp     byte[contador_ocas], 12
    jne     FinChequeo
    mov     byte[estado_juego], 1
    mov     byte[victoria], "Z"
    ret

FinChequeo:
    ret

ContabilizarMovimiento:
    ;Chequeo si el movimiento es diagonal, ya que es igual para todos los tableros
    ;Calcula la diferencia entre la fila inicial y final
    mov     cl, [fila_mov]
    sub     cl, [fila_zorro]
    ; Calcula la diferencia entre la columna inicial y final
    mov     dl, [columna_mov]
    sub     dl, [columna_zorro]
    ; Compara las dos diferencias
    cmp     cl, dl
    je      MovimientoDiagonal
    ; Si las diferencias no son iguales, compara en caso negativo de uno de ellos
    neg     cl
    cmp     cl, dl
    je      MovimientoDiagonal
    ; Si llegamos aquí, el movimiento no es diagonal
    ;Chequeo en que tablero se juega, para conocer las direcciones
    cmp     byte[eleccion_tablero], "1"
    je      ContabilizarMovimiento1
    cmp     byte[eleccion_tablero], "2"
    je      ContabilizarMovimiento2
    cmp     byte[eleccion_tablero], "3"
    je      ContabilizarMovimiento3
    cmp     byte[eleccion_tablero], "4"
    je      ContabilizarMovimiento4

ContabilizarMovimiento1:
    ;Chequeo si el zorro se movio hacia adelante
    mov     cl, [fila_mov]
    sub     cl, [fila_zorro]
    cmp     cl, -1
    je      MovimientoAdelante
    ;Chequeo si el zorro se movio hacia atras
    cmp     cl, 1
    je      MovimientoAtras
    ;Chequeo si el zorro se movio hacia la derecha
    mov     dl, [columna_mov]
    sub     dl, [columna_zorro]
    cmp     dl, 1
    je      MovimientoDerecha
    ;Chequeo si el zorro se movio hacia la izquierda
    cmp     dl, -1
    je      MovimientoIzquierda

ContabilizarMovimiento2:
    ;Chequeo si el zorro se movio hacia adelante
    mov     dl, [columna_mov]
    sub     dl, [columna_zorro]
    cmp     dl, 1
    je      MovimientoAdelante
    ;Chequeo si el zorro se movio hacia atras
    cmp     dl, -1
    je      MovimientoAtras
    ;Chequeo si el zorro se movio hacia la derecha
    mov     cl, [fila_mov]
    sub     cl, [fila_zorro]
    cmp     cl, 1
    je      MovimientoDerecha
    ;Chequeo si el zorro se movio hacia la izquierda
    cmp     cl, -1
    je      MovimientoIzquierda

ContabilizarMovimiento3:
    ;Chequeo si el zorro se movio hacia adelante
    mov     dl, [columna_mov]
    sub     dl, [columna_zorro]
    cmp     dl, -1
    je      MovimientoAdelante
    ;Chequeo si el zorro se movio hacia atras
    cmp     dl, 1
    je      MovimientoAtras
    ;Chequeo si el zorro se movio hacia la derecha
    mov     cl, [fila_mov]
    sub     cl, [fila_zorro]
    cmp     cl, -1
    je      MovimientoDerecha
    ;Chequeo si el zorro se movio hacia la izquierda
    cmp     cl, 1
    je      MovimientoIzquierda


ContabilizarMovimiento4:
    ;Chequeo si el zorro se movio hacia adelante
    mov     cl, [fila_mov]
    sub     cl, [fila_zorro]
    cmp     cl, 1
    je      MovimientoAdelante
    ;Chequeo si el zorro se movio hacia atras
    cmp     cl, -1
    je      MovimientoAtras
    ;Chequeo si el zorro se movio hacia la derecha
    mov     dl, [columna_mov]
    sub     dl, [columna_zorro]
    cmp     dl, -1
    je      MovimientoDerecha
    ;Chequeo si el zorro se movio hacia la izquierda
    cmp     dl, 1
    je      MovimientoIzquierda

;Contabilizo el movimiento en las variables que luego sirven para las estadisticas
MovimientoAdelante:
    inc     byte[mov_adelante]
    ret

MovimientoAtras:
    inc     byte[mov_atras]
    ret

MovimientoDerecha:
    inc     byte[mov_derecha]
    ret
    
MovimientoIzquierda:
    inc     byte[mov_izquierda]
    ret

MovimientoDiagonal:
    inc     byte[mov_diagonal]
    ret

MovimientoOcas:
    ;Imprimo mensaje para avisar al usuario que es turno de las ocas
    mPuts   mensaje_ocas1
    ;Leo el movimiento de la oca
    mGets   input_pos_oca
    ;Chequeo si el usuario quiere ayuda
    cmp     byte[input_pos_oca], "A"
    je      AyudaUsuario
    ;Chequeo si el usuario quiere salir del juego
    cmp     byte[input_pos_oca], "S"
    je      SalirPartida
    ;Chequeo si el usuario quiere guardar del juego
    cmp     byte[input_pos_oca], "G"
    je      GuardarPartida
    ;Chequeo si el usuario quiere editar el tablero
    cmp     byte[input_pos_oca], "E"
    je      EdicionZorro
    ;Parseo la posicion de la oca
    mov     rdi, input_pos_oca
    mov     rsi, formato_mov
    mov     rdx, fila_oca
    mov     rcx, columna_oca
    mov     r8, extra
    mScanf
    ;Chequeo que lo enviado sea valido
    cmp     rax, 2
    jne     MensajeErrorMovimientos
    ;Limpio registros para calcular desplazamiento sin problemas
    xor     rcx, rcx
    xor     rdx, rdx
    ;Busco posicion del tablero de la oca que se quiere mover
    mov     cl, [fila_oca]
    dec     cl
    imul    cx, 7
    mov     dl, [columna_oca]
    dec     dl
    add     cl, dl
    sub     dl, dl
    ;Hago los chequeos, informo del error en caso de problemas
    mov     dl, byte[tablero + rcx]
    cmp     dl, byte[oca]
    jne     MensajeErrorMovimientos
    ;Si llego aca, todo esta en orden. Ahora pido el movimiento de la oca
    mPuts   mensaje_ocas2
    mGets   input_mov
    ;Chequeo si el usuario quiere ayuda
    cmp     byte[input_mov], "A"
    je      AyudaUsuario
    ;Chequeo si el usuario quiere salir del juego
    cmp     byte[input_mov], "S"
    je      SalirPartida
    ;Chequeo si el usuario quiere guardar del juego
    cmp     byte[input_mov], "G"
    je      GuardarPartida
    ;Chequeo si el usuario quiere editar el tablero
    cmp     byte[input_mov], "E"
    je      EdicionZorro
    ;Parseo el movimiento de la oca
    mov     rdi, input_mov
    mov     rsi, formato_mov
    mov     rdx, fila_mov
    mov     rcx, columna_mov
    mov     r8, extra
    mScanf
    ;Chequeo que lo enviado sea valido
    cmp     rax, 2
    jne     MensajeErrorMovimientos
    ;Chequeo que el movimiento sea valido
    xor     rcx, rcx
    xor     rdx, rdx
    mov     cl, [fila_mov]
    dec     cl 
    imul    cx, 7
    mov     dl, [columna_mov]
    dec     dl
    add     cl, dl
    sub     dl, dl
    mov     dl, [tablero + rcx]
    cmp     dl, byte[vacio]
    jne     MensajeErrorMovimientos
    ;Chequeo que no sea un movimiento en diagonal ni que se quede quieto
    xor     rcx, rcx
    xor     rdx, rdx
    mov     cl, [fila_mov]
    sub     cl, [fila_oca]
    cmp     cl, 0
    jne     FilasDistintas
    mov     dl, [columna_mov]
    sub     dl, [columna_oca]
    cmp     dl, 0
    jne     ColumnasDistintas
    ;Si llego aca, el movimiento es valido, chequeo que no este pisando una oca, ni al zorro, ni saliendose del tablero
    jmp     QueTableroSeJuega

FilasDistintas:
    ;Si las filas son distintas, Las columnas deben ser iguales
    mov     dl, [columna_mov]
    sub     dl, [columna_oca]
    cmp     dl, 0
    je      QueTableroSeJuega
    jmp     MensajeErrorMovimientos

ColumnasDistintas:
    ;Si las columnas son distintas, Las filas deben ser iguales
    mov     dl, [fila_mov]
    sub     dl, [fila_oca]
    cmp     dl, 0
    je      QueTableroSeJuega
    jmp     MensajeErrorMovimientos

QueTableroSeJuega:
    ;Chequeo con que tablero se juega para conocer como hacer las validaciones
    cmp     byte[eleccion_tablero], "1"
    je      MovimientoOcas1
    cmp     byte[eleccion_tablero], "2"
    je      MovimientoOcas2
    cmp     byte[eleccion_tablero], "3"
    je      MovimientoOcas3
    cmp     byte[eleccion_tablero], "4"
    je      MovimientoOcas4

;Caso en que las ocas estan arriba: Solo puede quedar o aumentar en 1 el valor de "fila_oca"
MovimientoOcas1:
    mov     cl, [fila_mov]
    sub     cl, [fila_oca]
    cmp     cl, 0   
    jl      MensajeErrorMovimientos
    cmp     cl, 1
    jg      MensajeErrorMovimientos
    mov     dl, [columna_mov]
    sub     dl, [columna_oca]
    cmp     dl, -1
    jl      MensajeErrorMovimientos
    cmp     dl, 1
    jg      MensajeErrorMovimientos
    jmp     MovimientoOcasValido

;Caso en que las ocas estan a la izquierda: Solo puede quedar o aumentar en 1 el valor de "columna_oca"
MovimientoOcas2:
    mov     cl, [fila_mov]
    sub     cl, [fila_oca]
    cmp     cl, -1   
    jl      MensajeErrorMovimientos
    cmp     cl, 1
    jg      MensajeErrorMovimientos
    mov     dl, [columna_mov]
    sub     dl, [columna_oca]
    cmp     dl, 0
    jl      MensajeErrorMovimientos
    cmp     dl, 1
    jg      MensajeErrorMovimientos
    jmp     MovimientoOcasValido

;Caso en que las ocas estan a la derecha: Solo puede quedar o disminuir en 1 el valor de "columna_oca"
MovimientoOcas3:
    mov     cl, [fila_mov]
    sub     cl, [fila_oca]
    cmp     cl, -1   
    jl      MensajeErrorMovimientos
    cmp     cl, 1
    jg      MensajeErrorMovimientos
    mov     dl, [columna_mov]
    sub     dl, [columna_oca]
    cmp     dl, -1
    jl      MensajeErrorMovimientos
    cmp     dl, 0
    jg      MensajeErrorMovimientos
    jmp     MovimientoOcasValido

;Caso en que las ocas estan a la derecha: Solo puede quedar o disminuir en 1 el valor de "fila_oca"
MovimientoOcas4:
    mov     cl, [fila_mov]
    sub     cl, [fila_oca]
    cmp     cl, -1   
    jl      MensajeErrorMovimientos
    cmp     cl, 0
    jg      MensajeErrorMovimientos
    mov     dl, [columna_mov]
    sub     dl, [columna_oca]
    cmp     dl, -1
    jl      MensajeErrorMovimientos
    cmp     dl, 1
    jg      MensajeErrorMovimientos
    jmp     MovimientoOcasValido

MovimientoOcasValido:
    ;Si llego aca, todo esta en orden. Primero borro la posicion anterior de la oca del tablero
    ;Limpio registros para calcular desplazamiento sin problemas
    xor     rcx, rcx
    xor     rdx, rdx
    mov     cl, byte[fila_oca]
    dec     cl
    imul    cx, 7
    mov     dl, byte[columna_oca]
    dec     dl
    add     cl, dl
    sub     dl, dl
    mov     dl, byte[vacio]
    mov     [tablero + rcx], dl
    ;Actualizo el tablero con la posicion nueva de la oca 
    xor     rcx, rcx
    xor     rdx, rdx
    mov     cl, byte[fila_mov]
    dec     cl
    imul    cx, 7
    mov     dl, byte[columna_mov]
    dec     dl
    add     cl, dl
    sub     dl, dl
    mov     dl, byte[oca]
    mov     [tablero + rcx], dl
    ;Cambio el turno
    mov     byte[turno], "Z"
    ret

;----------------------------------------------------------------------------------------------------------

;Esta pequeña funcion se encarga de mostrar un mensaje de error en caso que un movimiento enviado por el usuario sea invalido, reinciando su turno y pidiendo un nuevo movimiento
MensajeErrorMovimientos:
    mPuts   mensaje_error
    cmp     byte[turno], "Z"
    je      MovimientoZorro
    jne     MovimientoOcas

;----------------------------------------------------------------------------------------------------------

;Rutina para que muestra un mensaje de ayuda por si el usuario olvido algun comando.
AyudaUsuario:
    ;Imprimo mensaje de ayuda
    mPuts  ayuda_usuario
    jmp    Movimientos
    ret

;----------------------------------------------------------------------------------------------------------

;Rutinas de salida y guardado de partida en el medio de la misma en caso que el usuario lo desee. Para el guardado, se sobrescribe el archivo 'partida.txt' con el tablero actual y se guardan
;las variables de utilidad para tener un correcto funcionamiento del juego en el futuro donde se cargue y vuelva a jugar con la partida guardada.
SalirPartida:
    mPuts  mensaje_salida
    mGets  input_salir
    cmp    byte[input_salir], "S"
    je     Salir
    cmp    byte[input_salir], "N"
    ret
    mPuts  mensaje_error
    jmp    SalirPartida

Salir:
    mov     byte[victoria], "S"
    mov     byte[estado_juego], 1
    ret

GuardarPartida:
    mov     byte[victoria], "G"
    mov     byte[de_donde], "G"
    sub     rsp,8
    call    AbrirArchivo
    add     rsp,8

LoopGuardadoTablero:
    ;Chequeo que todavia quede tablero por guardar
    cmp     rbx,49
    je      FinGuardadoTablero
    ;Guardo el tablero en el archivo
    mov     dl, [tablero + rbx]
    mov     [aux_archivo], dl
    mFPutsConSalto  aux_archivo, fileHandler, salto_archivo
    ;Itero
    inc     rbx
    jmp     LoopGuardadoTablero

FinGuardadoTablero:
    ;Guardo las variables necesarias para poder volver a jugar la partida guardada
    mFPutsConSalto  turno, fileHandler, salto_archivo
    mSprintf        numero_string, formato_pasaje, fila_zorro
    mFPutsConSalto  numero_string, fileHandler, salto_archivo
    mSprintf        numero_string, formato_pasaje, columna_zorro
    mFPutsConSalto  numero_string, fileHandler, salto_archivo
    mFPutsConSalto  oca, fileHandler, salto_archivo
    mFPutsConSalto  zorro, fileHandler, salto_archivo
    mSprintf        numero_string, formato_pasaje, mov_adelante
    mFPutsConSalto  numero_string, fileHandler, salto_archivo
    mSprintf        numero_string, formato_pasaje, mov_atras
    mFPutsConSalto  numero_string, fileHandler, salto_archivo
    mSprintf        numero_string, formato_pasaje, mov_derecha
    mFPutsConSalto  numero_string, fileHandler, salto_archivo
    mSprintf        numero_string, formato_pasaje, mov_izquierda
    mFPutsConSalto  numero_string, fileHandler, salto_archivo
    mSprintf        numero_string, formato_pasaje, mov_diagonal
    mFPutsConSalto  numero_string, fileHandler, salto_archivo
    mSprintf        numero_string, formato_pasaje, contador_ocas
    mFPutsConSalto  numero_string, fileHandler, salto_archivo
    ;Cierro el archivo
    mov     rdi, [fileHandler]
    sub     rsp,8
    call    fclose
    add     rsp, 8
    jmp     Finalizar

;----------------------------------------------------------------------------------------------------------

;Rutinas que generalizan la apertura del archivo 'partida.txt' para que no haga falta estar escribiendo todo este texto cada vez que sea necesario el uso del archivo. Se tienen en cuenta ambos
;modos de apertura, tanto para guardar como para cargar la partida.
AbrirArchivo:
    cmp     byte[de_donde], "G"
    je      AbrirParaGuardar
    jne     AbrirParaCargar

AbrirParaGuardar:
    xor     rax, rax
    ;Abro el archivo para guardar la partida
    mov     rdi, archivo
    mov     rsi, modo_guardar
    sub     rsp,8
    call    fopen
    add     rsp,8
    ;Chequeo si se abrio correctamente
    cmp     rax, 0
    jne     AperturaOK
    mPuts   men_error_arch
    ret

AbrirParaCargar:
    xor     rax, rax
    ;Abro el archivo para guardar la partida
    mov     rdi, archivo
    mov     rsi, modo_leer
    sub     rsp,8
    call    fopen
    add     rsp,8
    ;Chequeo si se abrio correctamente
    cmp     rax, 0
    jne     AperturaOK
    mPuts   men_error_arch
    ret

AperturaOK:
    mov     [fileHandler], rax
    xor     rbx, rbx
    xor     rdx, rdx
    ret

;-----------------------------------------------------------------------------------------------------------

;Rutinas finales, donde se muestran tanto las estadisticas del juego, como un mensaje final indicando como se termino la partida, ya sea por la victoria de algunio de los jugadores o por la
;decision del usuario de salir habiendo guardado o no la misma.
Estadisticas: 
    sub     rsp,8
    call    ImprimirTablero
    add     rsp,8
    cmp     byte[victoria], "Z"
    je      VictoriaZorro
    cmp     byte[victoria], "O"
    je      VictoriaOcas
    cmp     byte[victoria], "S"
    je      SalidaPorComando
    cmp     byte[victoria], "G"
    je      GuardadaPorComando

VictoriaZorro:
    mPuts   gano_zorro
    jmp     EstadisticasFinales

VictoriaOcas:
    mPuts   gano_ocas
    jmp     EstadisticasFinales

SalidaPorComando:
    mPuts   salida_mensaje
    jmp     EstadisticasFinales

GuardadaPorComando:
    mPuts   guardada_mensaje
    jmp     EstadisticasFinales

EstadisticasFinales:
    mov     rdi, mensaje_est
    mov     rsi, [mov_adelante]
    mov     rdx, [mov_atras]
    mov     rcx, [mov_derecha]
    mov     r8, [mov_izquierda]
    mov     r9, [mov_diagonal]
    mPrintf
    mov     rdi, ocas_comidasf
    mov     rsi, [contador_ocas]
    mPrintf
    jmp     Finalizar

Finalizar:
    mov     byte[estado_juego], 1
    ret 