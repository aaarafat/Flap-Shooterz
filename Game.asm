include p1m.inc 
include barrier.inc
.model small
.stack
.data
plen   equ  20      ; height and width of player
p1x    dw   0      ; left upper cornder 
p1y    dw   2   
m1x    dw   0       ; right bottom corner 
m1y    dw   0  
p1cl   db   09h     ; p1 body color
p1cd   db   01h     ; p1 link color
Pipx dw 0 
seed dw 0
Gap dw 0 ; y of the gap in pipe
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
    mov Pipx ,100
	getrandom Gap seed
    mov Running, 1
GameLoop:
	
    ; Clear
    Call Clear
		dec Pipx
    cmp Pipx,-1
	jnz nowrap
		mov Pipx,100
		getrandom Gap seed
	nowrap:
	; Get Input
    Call GetInput   
    ; Draw
    Call Draw
    ; Delay
    Call Delay
	; detect collision
	Call Collision
    cmp Running, 1                                  
    je GameLoop 
    
    
	mov ah, 4ch
	int 21h
	
main endp


;------Clear Screen----- 
Clear proc
    ClearP1 p1x, p1y, plen, m1x , m1y ; Clear Player1
	DeletePipe Pipx ,Gap
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
    
    DrawPipe Pipx , Gap  
	DrawP1 p1x, p1y, plen, m1x , m1y , p1cl , p1cd
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
;---------------------
;-collision Function--
Collision proc
	; is the spaceship inside the tunnel or not in x axis
	mov ax ,Pipx
	cmp ax,20
	jg complete
	;is the spaceship inside the tunnel or not in y axis
    mov ax, p1y
	sub ax,Gap
	;alaways the different bettwen the gap and the spaceship y is 2
	cmp ax,2
	jz complete
		mov Running ,0
	complete:
	ret 
collision endp
;----------------------- 
end main