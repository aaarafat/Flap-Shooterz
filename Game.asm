include p1m.inc
include barrier.inc
;include shoot.inc
include logic.inc
include weapons.inc
.model small
.stack
.data

ScreenWidth equ 320

plen   equ  20      ; height and width of player
slen    equ 4
swidquart    equ 2

;============Player 1================
p1x    dw   0      ; left upper corner
p1y    dw   2
m1x    dw   0       ; right bottom corner
m1y    dw   0
p1cl   db   09h     ; p1 body color
p1cd   db   01h     ; p1 link color
bul1x dw 0h   ;p1 bullet x
bul1y dw 0h   ;p1 bullet y
p1lives db 5h
p1invc db 0h ;invincible
CurrentWeapon1 db 3  
;=====================================

;============Player 2=================
p2x    dw   300      ; left upper corner
p2y    dw   2
m2x    dw   0       ; right bottom corner
m2y    dw   0
p2cl   db   0Ch     ; p2 body color
p2cd   db   04h     ; p2 link color
bul2x dw 0h   ;p2 bullet x
bul2y dw 0h   ;p2 bullet y
p2lives db 5h
p2invc db 0h ;invincible
CurrentWeapon2 db 3  
;======================================


Pipx1 dw 0;pipe of first player
Pipx2 dw 0;pipe of second player
Gap1 dw 0;gap in first pipe
Gap2 dw 0;gap in second pip
seed db 0
Running db  0h
P1Tunnel dw   0h
P2Tunnel dw   0h
TunnelSize dw 24

;------Weapon Colors-------------- 
djcolor   db   05h,05h,05h,05h,0dh,0dh,0dh,0dh,0dh,0dh,0dh,0dh,05h,05h,05h,05h  
hjcolor   db   00h,0ah,02h,00h,0ah,02h,02h,02h,02h,02h,02h,0ah,00h,02h,0ah,00h
ddcolor   db   04h,00h,00h,04h,00h,0ch,0ch,00h,00h,0ch,0ch,00h,04h,00h,00h,04h
fcolor    db   0fh,03h,03h,0fh,03h,0fh,0fh,03h,03h,0fh,0fh,03h,0fh,00h,03h,0fh  
;---------------------------------


.code
main proc far
    mov ax,@data
    mov ds,ax
    ; change graphics mode
    mov ah,0
    mov al,13h
    int 10h

    mov Pipx1 ,155
    getrandom Gap1 seed
    mov Pipx2 ,160
    getrandom Gap2 seed
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
    clearhearts p1lives, p2lives
    ClearP p1x, p1y, plen, m1x , m1y ; Clear Player1
    ClearP p2x, p2y, plen, m2x , m2y ; Clear Player1
    DeletePipe Pipx1 ,Gap1
    DeletePipe Pipx2 ,Gap2
    cmp bul1x, 0
    je noclear
	ClearB bul1x, bul1y
    ;DrawShoot s1x, s1y, slen, swidquart, 0h, 0h, 0h
noclear:
    ret
Clear endp
;-----------------------

;------Get Input-----
GetInput proc
    PlayerInput  11h , 1fh  , 39h , P1Tunnel , p1x , p1y , plen , bul1x , bul1y , slen
    PlayerInput  48h , 50h  , 1Ch , P2Tunnel , p2x , p2y , plen , bul2x , bul2y , slen

    ; IF Q PRESSED CLOSE
    CMP AH, 10H     ; Q
    JNE FLUSH
    MOV Running, 0
    ;-------------------
FLUSH:
    ; Flush Keyboard Buffer
    mov ah,0ch
    mov al,0
    int 21h
    ret
GetInput endp
;-----------------------

;------Draw Function----
Draw proc
    ;draw first pipe
    DrawPipe Pipx1 , Gap1
    ;draw second pipe
    DrawPipe Pipx2 , Gap2
    ; Draw Player 1
    DrawP p1x, p1y, plen, m1x , m1y , p1cl , p1cd
    ; Draw Player 2
    DrawP p2x, p2y, plen, m2x , m2y , p2cl , p2cd
    cmp bul1x, 0
    jz noshoot
	Fire CurrentWeapon1, bul1x, bul1y
    ;DrawShoot s1x, s1y, slen, swidquart, 0fh, 04h, 0Bh
noshoot:
    drawhearts p1lives,p2lives
    ret

Draw endp
;-----------------------

;------Delay Function----
Delay proc
mov di, 1
mov ah, 0
int 1Ah ; actual time
mov bx,dx
delayloop:
        mov ah, 0
        int 1Ah
        sub dx,bx
        cmp di,dx
ja delayloop


    ret

Delay endp
;---------------------
;----Update Function--
Update proc

    MoveB bul1x
    ; UPDATE PLAYER
    UpdatePlayer P1Tunnel, TunnelSize, p1y, plen
    UpdatePlayer P2Tunnel, TunnelSize, p2y, plen
    ;--------------
    ; GENERATE PIP 1
    GeneratePip  2,Pipx1,ScreenWidth,p1invc,Gap1, seed, 0
    ; GENERATE PIP 2
    GeneratePip  -2,Pipx2,ScreenWidth,p2invc,Gap2, seed, 4
    ;------------
    ; CHECK IF PLAYER HIT THE PIP
    CheckCollision Gap1, P1Tunnel, Pipx1, p1x, p1invc, p1lives, Running, 0
    CheckCollision Gap2, P2Tunnel, Pipx2, p2x, p2invc, p2lives, Running, 4

    ret
Update endp
;-----------------------
end main
