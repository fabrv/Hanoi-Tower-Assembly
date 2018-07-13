.model small
.stack 100
.data
    ;mensajes de resultados
    rPrompt db 10, 13, 'mover de $'
    rPrompt2 db ' a $'

    ri db ?; (result init) estas son las variables que voy a imprimir
    rt db ?; (result to)

    ;cinco lineas de texto para imprimir un titulin chilero
    title1 db '##     ##    ###    ##    ##  #######  ####', 10, 13, '$'
    title2 db '##     ##  ##   ##  ####  ## ##     ##  ## ', 10, 13, '$'
    title3 db '######### ##     ## ## ## ## ##     ##  ## ', 10, 13, '$'
    title4 db '##     ## ######### ##  #### ##     ##  ## ', 10, 13, '$'
    title5 db '##     ## ##     ## ##    ##  #######  ####', 10, 13, '$'

    ;mensaje para que el usuario sepa que hay que ingresar    
    nPrompt db 10,13, 'Cantidad de discos (numero menor a 5): $'
    ePrompt db 10,13, 'Tiene que ser un numero menor a 5, volver a ingresar$'
    fPrompt db 10,13, 10, 13, 'Final de las instrucciones   :-)$'

    f dw 1; nombre para desplegar torre inicial
    t dw 3; nombre para desplegar torre meta
    s dw 2; nombre para desplegar torre sobrante
    n dw 3; cantidad de discos
.code
    mov ax, @data
    mov ds, ax

    main proc
        sub bp, 2
        mov [bp], bp        
        mov bp, sp
        call printT

        .inputN:
            lea dx, nPrompt
            mov ah, 9
            int 21h
            mov AH,1; leer linea, hacer eco y mover a n
            int 21H
            cbw; Convert Byte to Word
            sub AX, '0'; STRIPPING ASCII        
            mov n, AX

            cmp n, 5
            jl .smaller
        .larger:
            mov al, 0; vaciar AL
            mov ah, 9; cambiar el color a rojo
            mov bl, 4; en bl se pasa el color y 4h es el rojo
            mov cx, 94
            int 10h; interrupcion 10h

            lea dx, ePrompt
            mov ah, 9
            int 21h
            jmp .inputN
        .smaller:

        mov ax, f; nombre de cada torre, empujada en orden al stack, +10
        sub bp, 2
        mov [bp], ax
        
        mov ax, t; +8
        sub bp, 2
        mov [bp], ax        
        
        mov ax, s; +6
        sub bp, 2
        mov [bp], ax        
        
        mov ax, n; +4
        sub bp, 2
        mov [bp], ax        


        mov sp, bp
        call hanoi       

        lea dx, fPrompt
        mov ah, 9
        int 21h
        mov AH,4CH; terminar programa
        int 21H
    main endp

    printT proc    
        mov ax, 03h; limpiar pantalla
        int 10h

        lea dx, title1
        mov ah, 9
        int 21h
        lea dx, title2
        mov ah, 9
        int 21h
        lea dx, title3
        mov ah, 9
        int 21h
        lea dx, title4
        mov ah, 9
        int 21h
        lea dx, title5
        mov ah, 9
        int 21h

        ret
    printT endp

    hanoi proc
        sub bp, 4
        mov [bp], bp
        cmp word ptr [bp+4], 0; si n es 0 entonces return, fin
        je .fin

        .onemore:
            mov ax, word ptr [bp+10]
            sub bp, 2
            mov [bp], ax            

            mov ax, word ptr [bp+8]; cambiar la torre 'spare' con la 'to' 
            sub bp, 2
            mov [bp], ax

            mov ax, word ptr [bp+12]
            sub bp, 2
            mov [bp], ax            
            
            mov ax, word ptr [bp + 10]
            dec ax; hacer (n-1), quitarle uno pa' continuar
            sub bp, 2
            mov [bp], ax; regresar al stack con 1 menos            

            mov sp, bp
            call hanoi; recursivity boii

            mov bp, sp
            mov ax, word ptr [bp+10]
            sub bp, 2
            mov [bp], ax

            mov ax, word ptr [bp+10]
            sub bp, 2
            mov [bp], ax  

            mov sp, bp
            call printI; print boi

            mov bp, sp
            mov ax, word ptr [bp+6]; mover la torre 'spare' a 'from' 
            sub bp, 2
            mov [bp], ax

            mov ax, word ptr [bp+10]; mover la torre 'spare' a 'from' 
            sub bp, 2
            mov [bp], ax

            mov ax, word ptr [bp+14]; y from a spare
            sub bp, 2
            mov [bp], ax

            mov ax, word ptr [bp+10]
            dec ax; hacer el n-1
            sub bp, 2
            mov [bp], ax; regresar al stack el valor ya restado

            mov sp, bp
            call hanoi; recursivity boiiiii

            mov bp, sp
            add bp, 2
            mov sp, bp
            ret 8
        .fin:
            add bp, 2
            mov sp, bp
            ret 8
    hanoi endp

    printI proc
        sub bp, 4
        push bp
        
        mov ri, '0'
        mov al, byte ptr [bp+6]
        add ri, al

        mov rt, '0'
        mov al, byte ptr [bp+4]
        add rt, al

        lea dx, rPrompt
        mov ah, 9
        int 21h
                
        mov dl, ri
        mov ah, 2
        int 21h

        lea dx, rPrompt2
        mov ah, 9
        int 21h

        mov dl, rt
        mov ah, 2
        int 21h

        pop bp
        ret 4
    printI endp
end