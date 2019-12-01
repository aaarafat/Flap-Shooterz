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
    inc SI
    cmp SI , 144  
    jl plop 
ENDM DeletePipe
;========================================================================================

;========================================================================================
getrandom  macro  Gap , seed
    mov ah,2ch    ; To get System Time
    int 21h
    mov aL,dh    ; Seconds is in DH 
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
GeneratePip macro speed,px,endpip,invc,Gap,seed
	local finish
	sub px,speed
    cmp px, endpip
	jnz finish
	mov invc ,0
    mov px,159 ;center of the screen    
    getrandom Gap seed
	finish:
	endm GeneratePip
;========================================================================================