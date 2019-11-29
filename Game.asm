include p1m.inc 
include barrier.inc
.model small
.stack
.data
plen   equ  20      ; height and width of player
p1x    dw   20      ; left upper cornder 
p1y    dw   2   
m1x    dw   0       ; right bottom corner 
m1y    dw   0  
p1cl   db   09h     ; p1 body color
p1cd   db   01h     ; p1 link color

Pipx dw 0 
seed db 0
Gap dw 0 
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
	
	;------------------
	;MainMenuLoop
	;------------------
GameLoop:
	
    ; Clear
    Call Clear
	; Get Input
    Call GetInput
    ; Update
	Call Update   
    ; Draw
    Call Draw
    ; Delay
    Call Delay
	; UI
	;Call UI
    cmp Running, 1                                  
    je GameLoop 
	
	
    ;------------------
	;GameOverLoop
	;------------------
    
	mov ah, 4ch
	int 21h
	
main endp


;------Clear Screen----- 
Clear proc
    ClearP1 p1x, p1y, plen, m1x , m1y ; Clear Player1
	DeletePipe Pipx , Gap
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
    jmp Return

MoveDown:
    cmp Tunnel, 5
    je Return
    INC Tunnel          
    
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
    DrawPipe Pipx , Gap  
	; Draw Player 1
    DrawP1 p1x, p1y, plen, m1x , m1y , p1cl , p1cd
    ret

Draw endp
;-----------------------
                           
;------Delay Function---- 
Delay proc                              
    mov ah, 86h        ;  1/10 second
    mov cx, 1h
    mov dx, 86A0h
    int 15h
    ret

Delay endp
;---------------------
;----Update Function--
Update proc 
    
    ; UPDATE PLAYER
    mov ax, Tunnel    ; TUNNEL ==> POSITION
    mul TunnelSize
    mov p1y, ax  
	mov ax , TunnelSize
	sub ax , plen
	shr ax , 1b
    ADD p1y, ax        ; PLAYER POS Aligned with the tunnel
    ;--------------
    
    ; GENERATE PIP 
    dec Pipx          ; TODO CHANGE SPEED LATER
    cmp Pipx,-1
	jnz nowrap
	mov Pipx,159	  ; Center of Screen   
	getrandom Gap seed  
	;------------
	
	nowrap:	
	; CHECK IF PLAYER HIT THE PIP
	; is the spaceship inside the tunnel or not in x axis
	;mov ax ,Pipx
	;cmp ax,20
	;jg complete
	;is the spaceship inside the tunnel or not in y axis
    ;mov ax, p1y
	;sub ax,Gap
	;alaways the different bettwen the gap and the spaceship y is 2
	;cmp ax,2
	;jz complete
	;mov Running ,0     ; Exit
	;-------------------------
	
	complete:
	ret 
Update endp
;----------------------- 
end main