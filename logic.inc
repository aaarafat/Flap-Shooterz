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
    jnz Complete
    mov Running ,0     ; Exit
    ;-------------------------
    NoCollision:
    mov invc, 0
    Complete:
ENDM CheckCollision
;========================================================================================
