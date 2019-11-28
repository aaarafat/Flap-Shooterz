
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
getrandom  macro  tunnel 
    mov ah,2ch    ; To get System Time
    int 21h
    mov aL,dh    ; Seconds is in DH 
    mov dl,3	;144-40-20/3=5 
    mov ah,0
	div dl
    mov al,ah
    mov ah,0
    mov dl,40
    mul dl
	add ax,20
    mov tunnel ,ax ;reminder
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