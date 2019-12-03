;========================================================================================
CheckCollision Macro Gap, Tunnel, Pipx, px, invc, plives, norm
    LOCAL NoCollision,Complete
    ; CHECK IF PLAYER HIT THE PIP
    ; CHECK IF PLAYER TUNNEL != PIP TUNNEL
    mov ax, GAP
    cmp ax, Tunnel
    JE NoCollision   ; If Equal No Collision
    ; CHECK THAAT PX + PLEN >= PIPX >= PX
    mov ax, Pipx
	add ax, norm
    cmp ax, px     ; IF equal or greater
    JL  NoCollision ; IF LOWER JUMP
    sub ax, plen    ; TO MAKE (Px + PLEN >= PIPX)  ==> (PX >= PIPX - PLEN)
    cmp ax, px     ; IF equal or lower
    JG NoCollision  ; IF GREATER JUMP
    ; (TODO CHANGE THIS LATER)
    ; If player is invincible then lives are the same
    cmp invc, 1
    jz Complete
    dec plives
    mov invc, 1
    cmp plives, 0
    jg Complete
    mov Running ,0     ; Exit
    ;-------------------------
    NoCollision:
    mov invc, 0
    Complete:
ENDM CheckCollision
;========================================================================================

;========================================================================================
CheckCollisionBullet Macro px, py, bulx, buly, BulletType, IsPlayer1, flag
 	LOCAL finish, PLAYER2, HandleEff, ShortJmp
	; If player 1 norm = plen normBul = 0 , player2 norm = 0 normBul = 4
	mov ax, bulx 
	cmp ax, 0
	jle ShortJmp
	; Todo (py + plen >= buly >= py) 
	mov ax, py
	cmp ax, buly
	jg ShortJmp
	add ax, plen
	cmp ax, buly
	jl ShortJmp
	mov ax, IsPlayer1
	jne PLAYER2
	; PLAYER1
	mov ax, px
	add ax, plen
	mov bx, bulx
	cmp ax, bx
	jl ShortJmp
	jmp HandleEff
ShortJmp:
    jmp finish
PLAYER2:	
	mov ax, px
	mov bx, bulx
	add bx, 4
	cmp ax, bx
	jl finish
HandleEff:
	mov flag, 0
	mov flag + 1, 0
	mov flag + 2, 0
	mov flag + 3, 0
	mov al, BulletType
	dec al
	mov ah, 0
	mov si, ax
    Add si, offset flag
	mov ax, 1
	mov [si], ax
	mov al, flag + 3
	mov dl, -1
	imul dl
	mov bulx, 0
	
dec p1lives
finish:
ENDM CheckCollisionBullet
;========================================================================================