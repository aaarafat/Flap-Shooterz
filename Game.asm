include p1m.inc
include barrier.inc
include shoot.inc
include logic.inc
.model small
.stack
.data
plen   equ  20      ; height and width of player
slen    equ 4
swidquart    equ 2
p1x    dw   0      ; left upper corner
p1y    dw   2
m1x    dw   0       ; right bottom corner
m1y    dw   0
p1cl   db   09h     ; p1 body color
p1cd   db   01h     ; p1 link color
s1x dw 0h   ;p2 shoot x
s1y dw 0h   ;p2 shoot y
p2x    dw   300      ; left upper corner
p2y    dw   2
m2x    dw   0       ; right bottom corner
m2y    dw   0
p2cl   db   0Ch     ; p2 body color
p2cd   db   04h     ; p2 link color
s2x dw 0h   ;p2 shoot x
s2y dw 0h   ;p2 shoot y
p1lives db 5h
p2lives db 5h
p1invc db 0h ;invincible
p2invc db 0h ;invincible

Pipx dw 0
Gap dw 0
seed db 0
Running db  0h
P1Tunnel dw   0h
P2Tunnel dw   0h
TunnelSize dw 24


.code
main proc far
    mov ax,@data
    mov ds,ax
    ; change graphics mode
    mov ah,0
    mov al,13h
    int 10h

    mov Pipx ,159
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

    ;clearing the hearts of player 1
    mov ah,2
    mov dx,0
    int 10h

    mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al, ' ' ;space
    mov cl, 5
    mov ch, 0
    mov bl,04h
    int 10h

    ClearP p1x, p1y, plen, m1x , m1y ; Clear Player1
	ClearP p2x, p2y, plen, m2x , m2y ; Clear Player1
    DeletePipe Pipx ,Gap
    cmp s1x, 0
    je noclear
    DrawShoot s1x, s1y, slen, swidquart, 0h, 0h, 0h
noclear:
    ret
Clear endp
;-----------------------

;------Get Input-----
GetInput proc
    PlayerInput  48h , 50h , 39h , P1Tunnel , p1x , p1y , plen , s1x , s1y , slen
	PlayerInput  11h , 1fh , 1Ch , P2Tunnel , p2x , p2y , plen , s2x , s2y , slen
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
    DrawP p1x, p1y, plen, m1x , m1y , p1cl , p1cd
	DrawP p2x, p2y, plen, m2x , m2y , p2cl , p2cd
    cmp s1x, 0
    jz noshoot 
    DrawShoot s1x, s1y, slen, swidquart, 0fh, 04h, 0Bh 

noshoot:
    mov ah,2
    mov dx,0
    int 10h
;drawing lives of player 1
    mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al, 3h ;heart
    mov cl, p1lives
    mov ch, 0
    mov bl,04h
    int 10h
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

    MoveShoot s1x, 320
    ; UPDATE PLAYER
    UpdatePlayer P1Tunnel, TunnelSize, p1y, plen
	UpdatePlayer P2Tunnel, TunnelSize, p2y, plen
    ;--------------
    ; GENERATE PIP
    GeneratePip  2,Pipx,-1,p1invc,Gap, seed
    ;------------
    ; CHECK IF PLAYER HIT THE PIP
    CheckCollision Gap, P1Tunnel, Pipx, p1x, p1invc, p1lives, Running
    
    ret
Update endp
;-----------------------
end main
