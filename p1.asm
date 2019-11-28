.model small
.stack
.data
plen dw 20 ; height and width of player
px   dw 50 ; left upper cornder 
py   dw 0   
mx   dw 0  ; right bottom corner 
my   dw 0
.code
main proc far 
    mov ax,@data
    mov ds,ax 
    
    
    mov ah,0
    mov al,13h
    int 10h
    
    mov AX , plen
    mov BL , 5   ; length of the link 
    div BL
    and AX , 0FFh
    mov BP , AX 
    
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
outlop:
    mov SI,px
    inlop:
        mov cx,SI 
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
outlop2:
    mov SI,px
    inlop2:
        mov cx,SI 
        mov dx,BX
        add dx,DI  ;draw below center
        mov al,09h ;body color
        mov ah,0ch 
        int 10h 
        mov cx,SI 
        mov dx,BX
        sub dx,DI  ;draw above center
        mov al,09h ;body color
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
outlop3:
    mov SI , px
    mov DX , plen 
    mov CL , 2
    shr DX , CL
    add SI , DX
    inlop3:
        mov cx,SI 
        mov dx,BX
        add dx,DI 
        mov al,01h ;body color
        mov ah,0ch 
        int 10h 
        mov cx,SI 
        mov dx,BX
        sub dx,DI 
        mov al,01h ;body color
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
	mov ah, 4ch
	int 21h
main endp 
end main