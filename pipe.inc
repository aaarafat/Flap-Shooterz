;========================================================================================
;------------Pipe Macro--------------

DrawPipe Macro px, tunnel
    Local plop
	Local Glop
	mov SI , 0
   plop:  
    mov CX , pipx
    mov DX , SI
    mov al,07h 
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
     
    mov SI , tunnel ; random value  
    mov BX , SI
    add BX , 24
    glop:
    mov DX , SI 
    mov al , 00h 
    mov CX , pipx 
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
    jl glop 

ENDM DrawPipe
;========================================================================================
