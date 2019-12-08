;========================================================================================
;------------Pipe Macro--------------
DrawPipe Macro px, tunnel
    Local plop, Glop
	mov SI , 0
   plop:
    mov CX , px
    mov DX , SI
    mov al,07h
    mov ah,0ch
    int 10h

    inc CX
    mov al,08h
    mov ah,0ch
    int 10h

    inc CX
    mov al,08h
    mov ah,0ch
    int 10h

    inc CX
    mov al,07h
    mov ah,0ch
    int 10h

    inc SI
    cmp SI , 144
    jl plop
    ;mutiply tunnel by 24
    mov ax,tunnel
    mov ah,0
    mov dl,24
    mul dl
    mov SI , ax ; random value
    mov BX , SI
    add BX , 24
    glop:
    mov DX , SI
    mov al , 00h
    mov CX , px
    mov ah , 0ch
    int 10h

    inc CX
    mov ah , 0ch
    int 10h

    inc CX
    mov ah , 0ch
    int 10h

    inc CX
    mov ah , 0ch
    int 10h

    inc SI
    cmp SI,BX
    jle glop

ENDM DrawPipe
;========================================================================================

;========================================================================================
DeletePipe Macro px, tunnel
    Local plop ,Glop
	mov SI , 0
   plop:
    mov CX , px
    mov DX , SI
    mov al,00h
    mov ah,0ch
    int 10h
    inc CX
    mov al,00h
    mov ah,0ch
    int 10h
    inc CX
    mov al,00h
    mov ah,0ch
    int 10h
    inc CX
    mov al,00h
    mov ah,0ch
    int 10h
    inc SI
    cmp SI , 144
    jl plop
ENDM DeletePipe
;========================================================================================

;========================================================================================
getrandom  macro  Gap
    mov ah,2ch    ; To get System Time
    int 21h
    mov aL,dl    ; 1/100 is in Dl
    mov ah,0
	inc seed
	add al,seed
	mov dl,6
    mov ah,0
	div dl
    mov al,ah
    mov ah, 0
	mov Gap ,ax ;reminder
endm getrandom
;========================================================================================
;========================================================================================
GeneratePip macro speed,px,invc,Gap,norm
	local finish,gen
	sub px,speed
    mov si, px
    add si, norm
    cmp si, ScreenWidth
	jg gen
    cmp si, -1
	jnl finish
gen:
    mov invc ,0
    mov px,160 ;center of the screen
    getrandom Gap, seed
	mov ax, norm
	cmp ax, 0
	jnz finish
	sub px, 5
	finish:
	endm GeneratePip
;========================================================================================
