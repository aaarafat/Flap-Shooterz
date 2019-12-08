include p1m.inc 
.model small
.stack
.data
plen   equ  20      ; height and width of player
p1x    dw   50      ; left upper cornder 
p1y    dw   0   
m1x    dw   0       ; right bottom corner 
m1y    dw   0  
p1cl   db   09h     ; p1 body color
p1cd   db   01h     ; p1 link color
th1x    DW 0
th1y    DW 0
th2x    DW 0
th2y	DW 0 
mt1x	DW 0
mt1y	DW 0
mt2x	DW 0
mt2y	DW 0
Running db  0h   
Tunnel dw   0h  
TunnelSize dw 24
.code
main proc far 
    mov ax,@data
    mov ds,ax 
    ; change graphics mode
    mov ah,0
    mov al,13h
    int 10h
    
	 ;player one
	 mov dx , th1y
	 olop1 :
	 mov cx , th1x
	 ilop1:
		 mov al , [SI]
		 ah,0ch 
         int 10h   
         inc cx 
         inc SI
         cmp cx,mt1x
         jl ilop1  
	inc dx  
    cmp dx , mt1y
    jl olop1
	;player two
	 mov dx , th2y
	 olop2 :
	 mov cx , th2x
	 ilop2:
		 mov al , [DI]
		 ah,0ch 
         int 10h   
         inc cx 
         inc DI
         cmp cx,mt2x
         jl ilop2 
	inc dx  
    cmp dx , mt2y
    jl olop2 
    
    
	mov ah, 4ch
	int 21h
	
main endp


;------Clear Screen----- 
Clear proc
    ClearP1 p1x, p1y, plen, m1x , m1y ; Clear Player1
    ret
Clear endp 
;-----------------------
    
;------Get Input----- 
GetInput proc
    mov ah, 1
    int 16h   ; Get Key Pressed
    jz Return ; If no Key Pressed Return
         
    ; Key Pressed
    cmp ah, 48h     ; IF UP ARROW MOVE UP
    je MoveUp
   
    cmp ah, 50h     ; IF DOWN ARROW MOVE DOWN
    je MoveDown
   
    mov Running, 0  ; Else Exit 
    jmp Return
    ;------------

MoveUp:
    cmp Tunnel, 0   
    je Return
    DEC Tunnel  
    jmp Update

MoveDown:
    cmp Tunnel, 6
    je Return
    INC Tunnel  
      
Update:
    mov ax, Tunnel
    mul TunnelSize
    mov p1y, ax     
    ADD p1y, 2
    
Return:
    ; Flush Keyboard Buffer
    mov ah,0ch
    mov al,0
    int 21h
    ret
GetInput endp 
;-----------------------   
    
;------Draw Function---- 
Draw proc  
    ; Draw Player 1
    DrawP1 p1x,p1y,plen,m1x,m1y,p1cl,p1cd
    DrawP1 280,p1y,plen,m1x,m1y,04h,p1cd 
    ret

Draw endp
;-----------------------
                           
;------Delay Function---- 
Delay proc  
    mov ah, 86h
    mov cx, 1h
    mov dx, 86A0h
    int 15h
    ret

Delay endp
;----------------------- 
end main