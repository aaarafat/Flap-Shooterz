
DeletePipe Macro px, tunnel
    Local plop
	Local Glop
	mov SI , 0
   plop:  
    mov CX , pipx
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
    inc SI
    cmp SI , 144  
    jl plop 
ENDM DeletePipe
getrandom  macro  Gap seed
    mov ah,2ch    ; To get System Time
    int 21h
    mov aL,dh    ; Seconds is in DH 
    inc seed
	add al,seed
	mov dl,6	
    mov ah,0
	div dl
    mov al,ah
    mov ah,0
    mov dl,24
    mul dl
	dec ax
	mov Gap ,ax ;reminder
endm getrandom 
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