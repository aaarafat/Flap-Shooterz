 deleteline macro
    local loop1
    mov dx,0
    mov my,dx
    mov ah,0ch
    mov al,0h
    mov bx,400
    ;bx is counter
	loop1:
    mov cx,mx
    mov dx,my
    int 10h
    inc dx
    mov my,dx
	dec bx
    jnz loop1
    
    endm deleteline
getrandom  macro seed random 
    mov ax,seed
    mov ah,2ch    ; To get System Time
    int 21h
    mov aL,dh    ; Seconds is in DH 
    mov dx,seed
	;mul seed by second
	mul dl
    mov ah,0
	;take mod 
    mov dl,5   ;300/60=5 
    div dl
    mov al,ah
    mov ah,0
    mov dl,60
    mul dl
    mov random ,ax ;reminder
endm getrandom 
 drawgap macro y
    local loop2
    mov dx,y
    mov my,dx
    mov ah,0ch
    mov al,00h
	mov bx,40
	;bx is counter
    loop2:
        mov cx,mx
        mov dx,my
        int 10h
        inc dx
        mov my,dx
        dec bx
    jnz loop2
    drawgap endm
 drawbarrier macro x 
    local loop3
    mov dx,0
    mov my,dx
    mov ah,0ch
    mov al,0fh
    mov bx,400
    loop3:
        mov cx,mx
        mov dx,my
        int 10h
        inc dx
        mov my,dx
        dec bx
    jnz loop3
    drawbarrier endm
