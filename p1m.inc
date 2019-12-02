;========================================================================================
;------------Player Macro--------------

DrawP Macro px,py,mx,my,p1cl,p1cd
	Local outlop,inlop,outlop2,inlop2,outlop3,inlop3
;************** intialize  **************
    mov SI,px
    mov DI,py
    add SI,plen
    mov mx,SI
    add DI,plen
    mov my,DI
    sub SI,plen
    sub DI,plen
;************** intialize  **************
;************** draw base  **************
    mov BP , plen  ; height of each on of the bases
	mov CL , 3
    shr BP , CL     ; 1/8  below center + 1/8 above the center = 1/4 of total height
    mov DI,  0
outlop: mov SI,px
inlop:  mov cx,SI
        mov dx,py
        add dx,DI
        mov al,0fh ;first color
        mov ah,0ch
        int 10h
        mov dx,my
        sub dx,DI
        mov al,0fh ;first color
        mov ah,0ch
        int 10h
        inc SI
        cmp SI , mx
        jl inlop ;end innerloop
    inc DI
    cmp DI , BP
    jl outlop ;end outterloop
;************** draw base **************

;************** draw body **************
    mov BP , plen
	mov CL , 02h
    shr BP , CL    ; 1/4  below center + 1/4 above the center = 1/2 of total height
    mov BX , plen
	mov CL , 01h
    shr BX , CL    ; center of the body (half of plen)
    add BX , py   ; move it to the new origin
    mov DI , 0    ; intialize counter
outlop2:mov SI,px
inlop2: mov cx,SI
        mov dx,BX
        add dx,DI  ;draw below center
        mov al,p1cl ;body color
        mov ah,0ch
        int 10h
        mov cx,SI
        mov dx,BX
        sub dx,DI  ;draw above center
        mov al,p1cl ;body color
        mov ah,0ch
        int 10h
        inc SI
        cmp SI , mx
        jl inlop2 ;end innerloop
    inc DI
    cmp DI , BP ;cmp counter to the half of height
    jl outlop2 ;end outterloop

    ;draw Link
    mov AX , plen
    mov BL , 5   ; length of the link
    div BL
    and AX , 0FFh
    mov BP , AX
    mov BX , plen  ; the center of the body
	mov CL , 01h
    shr BX , CL
    mov DI , plen
	mov CL , 02h
    shr DI , CL
    add BP, DI   ; start the link after 10 pixels from the center
    add BX , py
    sub mx , DI
outlop3:mov SI , px
    mov DX , plen
    mov CL , 2
    shr DX , CL
    add SI , DX
inlop3:mov cx,SI
        mov dx,BX
        add dx,DI
        mov al,p1cd ;body color
        mov ah,0ch
        int 10h
        mov cx,SI
        mov dx,BX
        sub dx,DI
        mov al,p1cd ;body color
        mov ah,0ch
        int 10h
        inc SI
        cmp SI , mx
        jl inlop3 ;end innerloop
    inc DI
    cmp DI , BP
    jl outlop3 ;end outterloop
    ;draw Link
;************** draw body **************
ENDM DrawP1
;========================================================================================

;========================================================================================
ClearP Macro px, py, mx, my
	Local olop,ilop
	mov ax , px
	mov bx , py
	mov mx , ax
	mov my , bx
	add mx , plen
	add my , plen
	mov DI , py
olop:mov SI , px
ilop:mov cx , SI
		mov dx , DI
        mov al,00h ;body color
        mov ah,0ch
        int 10h
        inc SI
        cmp SI , mx
        jle ilop ;end innerloop
    inc DI
    cmp DI , my
    jle olop ;end outterloop

ENDM ClearP1
;========================================================================================
;========================================================================================
UpdatePlayer Macro Tunnel, p1y
    ; UPDATE PLAYER
    mov ax, Tunnel    ; TUNNEL ==> POSITION
    mul TunnelSize
    mov p1y, ax
    mov ax , TunnelSize
    sub ax , plen
    shr ax , 1b
    ADD p1y, ax        ; PLAYER POS Aligned with the tunnel

ENDM UpdatePlayer
;========================================================================================
;========================================================================================
PlayerInput Macro Up , Down , Shoot , Tunnel , px , py , bulx , buly
	LOCAL MoveUp,MoveDown,PShoot,Return
	mov ah, 1
    int 16h   ; Get Key Pressed
    jz Return ; If no Key Pressed Return

    ; Key Pressed
    cmp ah, Up     ; IF UP ARROW MOVE UP
    je MoveUp

    cmp ah, Down     ; IF DOWN ARROW MOVE DOWN
    je MoveDown

    cmp ah, Shoot     ; IF SPACE SHOOT
    je PShoot

    jmp Return
    ;------------

MoveUp:
    cmp Tunnel, 0
    je Return
    DEC Tunnel
    jmp Return

MoveDown:
    cmp Tunnel, 5
    je Return
    INC Tunnel
    jmp Return
PShoot:
    cmp bulx, 0       ; IF SHOOT.X = 0 RETURN
    jne Return
    mov ax, px
    add ax, plen     ; MOVE SHOOT TO THE PLAYER HEAD
    mov bulx, ax
    mov ax, py
    add ax, plen / 2 - slen / 2    ; MOVE SHOOT TO VERT CENTER OF THE PLAYER
    mov buly, ax

Return:
		NOP
ENDM	PlayerInput
;========================================================================================
;========================================================================================
drawhearts Macro p1lives,p2lives
; move cursor
    mov ah,2
    mov dx,0
    int 10h
;drawing lives of player 1
    mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al, 3h ;heart
    mov cl, p1lives
    mov ch, 0
    mov bl,09h
    int 10h

; move cursor
	mov ah, 2
	mov dl,40
	sub dl,p2lives
	mov dh,0
	mov bh,0
	int 10h
;drawing lives of player 2
	mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al, 3h ;heart
    mov cl, p2lives
    mov ch, 0
    mov bl,04h
    int 10h
endm drawhearts
;========================================================================================
clearhearts Macro p1lives,p2lives
; move cursor
    mov ah,2
    mov dx,0
    mov bh, 0
    int 10h
;clearing lives of player 1
    mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al, ' ' ;space
    mov cl, p1lives
    mov ch, 0
    mov bl,09h
    int 10h

; move cursor
	mov ah, 2
	mov dl,40
	sub dl,p2lives
	mov dh,0
	mov bh,0
	int 10h
;clearing lives of player 2
	mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al, ' ' ;space
    mov cl, p2lives
    mov ch, 0
    mov bl,04h
    int 10h
endm clearhearts
