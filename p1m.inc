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
PlayerInput Macro Up,Down,Shoot,ChangeWeaponR,ChangeWeaponL,Tunnel,px,py,bulx,buly,W,CurrentBullet,IsPlayer1,FreezeFlag,InvertFlag,DoubleJumpFlag
	LOCAL MoveUp,MoveDown,PShoot,Return,PLAYER2,WeaponL,WeaponR,ToRightMostWeapon,ToLeftMostWeapon,CheckWeapon,SmallJmp1,SmallJmp2,SkipMove,CheckDown
	mov ah, 1
    int 16h   ; Get Key Pressed
    jz SmallJmp1 ; If no Key Pressed Return
	cmp FreezeFlag, 1
	je SkipMove
    ; Key Pressed
    cmp ah, Up     ; IF UP ARROW MOVE UP
    jne CheckDown
	cmp InvertFlag, 1
	je MoveDown
	jmp MoveUp
CheckDown:
    cmp ah, Down     ; IF DOWN ARROW MOVE DOWN
    jne SkipMove
	cmp InvertFlag, 1
	je MoveUp
	jmp MoveDown
SkipMove:
    cmp ah, Shoot     ; IF SPACE SHOOT
    je PShoot
	cmp ah, ChangeWeaponR
	je WeaponR
	cmp ah, ChangeWeaponL
	je WeaponL
SmallJmp1:
    jmp SmallJmp2
MoveUp:
    cmp Tunnel, 0
    je SmallJmp2
    dec Tunnel
	cmp Tunnel, 0
    je SmallJmp2
	cmp DoubleJumpFlag, 0
	je SmallJmp2
	dec Tunnel
	jmp SmallJmp2
MoveDown:
    cmp Tunnel, 5
    je SmallJmp2
    inc Tunnel
	cmp Tunnel, 5
    je SmallJmp2
	cmp DoubleJumpFlag, 0
	je SmallJmp2
	inc Tunnel
	jmp SmallJmp2
SmallJmp2: 
    jmp Return
PShoot:
    cmp bulx, 0       ; IF SHOOT.X = 0 RETURN
    jne Return
	mov ah, W
	mov CurrentBullet, ah
    mov ax, px
	mov bx, IsPlayer1
    cmp bx, 0
	jz PLAYER2
    add ax, plen     ; MOVE SHOOT TO THE PLAYER HEAD
PLAYER2:
    mov bulx, ax
    mov ax, py
    add ax, plen / 2 - slen / 2    ; MOVE SHOOT TO VERT CENTER OF THE PLAYER
    mov buly, ax
	jmp Return
WeaponR:
	inc W
	jmp CheckWeapon
WeaponL:
	dec W
CheckWeapon:
    mov ah, W
	cmp ah, 1
	jl ToRightMostWeapon
	cmp ah, 4
	jg ToLeftMostWeapon
	jmp Return
ToRightMostWeapon:
	mov W, 4
	jmp Return
ToLeftMostWeapon:
	mov W, 1
Return:
		NOP
ENDM	PlayerInput
;========================================================================================
;========================================================================================
drawhearts Macro p1lives,p2lives
	push es
	mov ax, ds
	mov es, ax

	add p1lives, '0'
	add p2lives, '0'
;drawing lives of player 1
    mov ah,13h ;Display
	mov al, 0h ;text mode
    mov bh,0 ;Page 0
    ;mov al, 3h ;heart
    ;mov cl, p1lives
    ;mov ch, 0
	mov cx, 3 ;string length
    mov bl,09h ;color
	mov dx, 0h ;set row, col
	lea bp, p1livesstr
    int 10h

;drawing lives of player 2
	mov ah,13h ;Display
	mov al, 0h ;text mode
    mov bh,0 ;Page 0
    ;mov al, 3h ;heart
    ;mov cl, p1lives
    ;mov ch, 0
	mov cx, 3 ;string length
    mov bl,04h ;color
	mov dx, 25h
	lea bp, p2livesstr

    int 10h
	pop es
	sub p1lives, '0'
	sub p2lives, '0'
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
    mov cl, 3
    mov ch, 0
    mov bl,09h
    int 10h

; move cursor
	mov ah, 2
	mov dl,37
	mov dh,0
	mov bh,0
	int 10h
;clearing lives of player 2
	mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al, ' ' ;space
    mov cl, 3
    mov ch, 0
    mov bl,04h
    int 10h
endm clearhearts
;========================================================================================
DrawTimer Macro timer1, flag1, timer2, flag2
	Local back1, back2, return1, return2, flag21, flag31, flag41, flag22, flag32, flag42
	mov bl, 6
	mov ax, timer1
	div bl
	mov ah, 0
	mov timer1, ax
	mov ax, timer2
	div bl
	mov ah, 0
	mov timer2, ax
	
	cmp timer1, 0
	je return1
	mov bh, 0h
	mov cx, timer1
	mov dx, 10h
	mov ah, 0ch
	cmp flag1, 1
	jne flag21
	mov al, 05h
	jmp back1
flag21:
	cmp flag1+2, 1
	jne flag31
	mov al, 02h
	jmp back1
flag31:
	cmp flag1 + 4, 1
	jne flag41
	mov al, 04h
    jmp back1	
flag41:
	mov al, 0fh	
back1: int 10h
	loop back1
return1:
	cmp timer2, 0
	je return2
	mov bh, 0h
	mov cx, timer2
	mov dx, 10h
	mov ah, 0ch
	cmp flag2, 1
	jne flag22
	mov al, 05h
	jmp back2
flag22:
	cmp flag2+2, 1
	jne flag32
	mov al, 02h
	jmp back2
flag32:
	cmp flag2 + 4, 1
	jne flag42
	mov al, 04h
    jmp back2	
flag42:
	mov al, 0fh	
back2: push cx
	mov bx, 320
	sub bx, cx
	mov cx, bx
	mov bx, 0
	int 10h
	pop cx
	loop back2
return2:	
	mov bl, 6
	mov ax, timer1
	mul bl
	mov timer1, ax
	mov ax, timer2
	mul bl
	mov timer2, ax
endm DrawTimer
;========================================================================================
ClearTimer Macro timer1, timer2
	Local back1, back2, return1, return2
	mov bl, 6
	mov ax, timer1
	div bl
	mov ah, 0
	mov timer1, ax
	mov ax, timer2
	div bl
	mov ah, 0
	mov timer2, ax
	
	cmp timer1, 0
	je return1
	mov bh, 0h
	mov cx, timer1
	mov dx, 10h
	mov ah, 0ch
	mov al, 00h
back1: int 10h
	loop back1
return1:
	cmp timer2, 0
	je return2
	mov bh, 0h
	mov cx, timer2
	mov dx, 10h
	mov ah, 0ch
	mov al, 00h
back2: push cx
	mov bx, 320
	sub bx, cx
	mov cx, bx
	mov bx, 0
	int 10h
	pop cx
	loop back2
return2:
    mov bl, 6
	mov ax, timer1
	mul bl
	mov timer1, ax
	mov ax, timer2
	mul bl
	mov timer2, ax
endm ClearTimer