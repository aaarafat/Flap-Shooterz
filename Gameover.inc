writewinner macro playercolor,winner,mesg1,mesg2 ,size
  LOCAL win2, win1
   mov ah,0
    mov al,13h
    int 10h
; move cursor
    mov ax,winner    
    cmp al,1
    jnz win2
    mov bp, offset msg1
    jmp win1
    win2: 
    mov bp, offset msg2
    win1:
    mov bl,playercolor  
    mov al, 1
    mov bh, 0
    mov cx, size
    mov dl, 12
    mov dh, 16
    push ds
    pop es
    mov ah, 13h
    int 10h
endm  writewinner    
 



