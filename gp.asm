	EXTRN gameover:far
	EXTRN choosecolor:far
	EXTRN sendproc:far
	EXTRN recproc:far
	EXTRN init:far
	EXTRN value:byte
	PUBLIC p1lives,p2lives
	EXTRN p1cd:byte,p2cd:byte,p1cl:byte,p2cl:byte
	EXTRN lvlOption:byte
	PUBLIC Game
	public Running
include p1m.inc
include barrier.inc
include logic.inc
include weapons.inc
include Gameover.inc
.model small
.stack 64
.data

ScreenWidth equ 320

plen   equ  20     ; height and width of player
slen    equ 4
swidquart    equ 2


;============Player 1================
br     dw   15
p1x    dw   20      ; left upper corner
p1y    dw   2
m1x    dw   0       ; right bottom corner
m1y    dw   0
;p1cl   db   09h     ; p1 body color
;p1cd   db   01h     ; p1 link color
bul1x dw 0h   ;p1 bullet x
bul1y dw 0h   ;p1 bullet y
p1livesstr label byte
p1lives db 5h
        db 'x',3h
p1invc db 0h ;invincible
CurrentWeapon1 db 1
CurrentBullet1 db 1
timerDur       equ 500
timerWdP       equ 6
Bspeed		   equ 12
timer1         dw 0
InvertFlag1 dw 0
DoubleJumpFlag1 dw 0
DoubleDamageFlag1 dw 0
FreezeFlag1 dw 0
Bullet1 dw 5,5,5,5
Bulletstr1 label byte
        db 'x'
CurrentBulletCount1 db 0h
;=====================================

;============Player 2=================
p2x    dw   280      ; left upper corner
p2y    dw   2
m2x    dw   0       ; right bottom corner
m2y    dw   0
;p2cl   db   0Ch     ; p2 body color
;p2cd   db   04h     ; p2 link color
bul2x dw 0h   ;p2 bullet x
bul2y dw 0h   ;p2 bullet y
p2livesstr label byte
        db 3h,'x'
p2lives db 5h
p2invc db 0h ;invincible
CurrentWeapon2 db 1
CurrentBullet2 db 1
timer2         dw 0
InvertFlag2 dw 0
DoubleJumpFlag2 dw 0
DoubleDamageFlag2 dw 0
FreezeFlag2 dw 0
Bullet2 dw 5,5,5,5
Bulletstr2 label byte
        db 'x'
CurrentBulletCount2 db 0h
;======================================
cp1d db 0
cp1l db 0
cp2d db 0
cp2l db 0

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
;--------THURSTS------------------
p1th0	DB  00h,00h,2Ah,2Ah,2Ah,2Ah
		DB  00h,2Ah,2Ah,2Ch,2Ch,2Ch
		DB  2Ah,2Ah,2Ch,2Ch,2Ch,2Ch
		DB  2Ah,2Ah,2Ch,2Ch,2Ch,2Ch
		DB  00h,2Ah,2Ah,2Ch,2Ch,2Ch
		DB  00h,00h,2Ah,2Ah,2Ah,2Ah
p1th1	DB  00h,00h,00h,2Ah,2Ah,2Ah
		DB  00h,00h,2Ah,2Ch,2Ch,2Ch
		DB  00h,2Ah,2Ch,2Ch,2Ch,2Ch
		DB  00h,2Ah,2Ch,2Ch,2Ch,2Ch
		DB  00h,00h,2Ah,2Ch,2Ch,2Ch
		DB  00h,00h,00h,2Ah,2Ah,2Ah
p1th2	DB  00h,00h,00h,2Ah,2Ah,2Ah
		DB  00h,00h,2Ah,2Ah,2Ch,2Ch
		DB  00h,2Ah,2Ah,2Ch,2Ch,2Ch
		DB  00h,2Ah,2Ah,2Ch,2Ch,2Ch
		DB  00h,00h,2Ah,2Ah,2Ch,2Ch
		DB  00h,00h,00h,2Ah,2Ah,2Ah
p1th3	DB  00h,00h,2Ah,2Ah,2Ah,2Ah
		DB  00h,2Ah,2Ah,2Ah,2Ch,2Ch
		DB  2Ah,2Ah,2Ah,2Ch,2Ch,2Ch
		DB  2Ah,2Ah,2Ah,2Ch,2Ch,2Ch
		DB  00h,2Ah,2Ah,2Ah,2Ch,2Ch
		DB  00h,00h,2Ah,2Ah,2Ah,2Ah
p2th0	DB  2Ah,2Ah,2Ah,2Ah,2Ah,00h
		DB  2Ch,2Ch,2Ch,2Ah,2Ah,00h
		DB  2Ch,2Ch,2Ch,2Ch,2Ah,2Ah
		DB  2Ch,2Ch,2Ch,2Ch,2Ah,2Ah
		DB  2Ch,2Ch,2Ch,2Ah,2Ah,00h
		DB  2Ah,2Ah,2Ah,2Ah,2Ah,00h
p2th1	DB  2Ah,2Ah,2Ah,00h,00h,00h
		DB  2Ch,2Ch,2Ch,2Ah,00h,00h
		DB  2Ch,2Ch,2Ch,2Ch,2Ah,00h
		DB  2Ch,2Ch,2Ch,2Ch,2Ah,00h
		DB  2Ch,2Ch,2Ch,2Ah,00h,00h
		DB  2Ah,2Ah,2Ah,00h,00h,00h
p2th2	DB  2Ah,2Ah,2Ah,00h,00h,00h
		DB  2Ch,2Ch,2Ah,2Ah,00h,00h
		DB  2Ch,2Ch,2Ch,2Ah,2Ah,00h
		DB  2Ch,2Ch,2Ch,2Ah,2Ah,00h
		DB  2Ch,2Ch,2Ah,2Ah,00h,00h
		DB  2Ah,2Ah,2Ah,00h,00h,00h
p2th3	DB  2Ah,2Ah,2Ah,2Ah,00h,00h
		DB  2Ch,2Ch,2Ah,2Ah,2Ah,00h
		DB  2Ch,2Ch,2Ch,2Ah,2Ah,2Ah
		DB  2Ch,2Ch,2Ch,2Ah,2Ah,2Ah
		DB  2Ch,2Ch,2Ah,2Ah,2Ah,00h
		DB  2Ah,2Ah,2Ah,2Ah,00h,00h
currSpr DB 0
frame   DB 0
th1x    DW 0
th1y    DW 0
th2x    DW 0
th2y	DW 0
mt1x	DW 0
mt1y	DW 0
mt2x	DW 0
mt2y	DW 0

;---------------------------------

.code
Game proc far
    mov ax,@data
    mov ds,ax

	; init all
    call initailize
	cmp lvlOption, 1
	je GameLoop
	mov Bullet2, -1
	mov Bullet2 + 2, -1
	mov Bullet2 + 4, -1
	mov Bullet2 + 6, -1
	mov Bullet2, -1
	mov Bullet2 + 2, -1
	mov Bullet2 + 4, -1
	mov Bullet2 + 6, -1
	mov CurrentBulletCount1, -1
	mov CurrentBulletCount2, -1
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

    
Game endp

;------Clear Screen-----
Clear proc
	ClearBullet                 ; clear bullet counter
    clearhearts p1lives, p2lives
    ClearP p1x, p1y, m1x , m1y ; Clear Player1
    ClearP p2x, p2y, m2x , m2y ; Clear Player2
    DeletePipe Pipx1 ,Gap1
    DeletePipe Pipx2 ,Gap2
    cmp bul1x, 0
    je noclear1  ; if bullet.x = 0 don't clear
	ClearB bul1x, bul1y
noclear1:
	cmp bul2x, 0 ; if bullet.x = 0 don't clear
	je noclear2
    ClearB bul2x, bul2y
noclear2:
	ClearTimer timer1, timer2   ; clear effect timer bar
    ret
Clear endp
;-----------------------

;------Get Input-----
GetInput proc
    ;PlayerInput  11h , 1fh  , 39h , 20h, 1eh, P1Tunnel , p1x , p1y , bul1x , bul1y, CurrentWeapon1, CurrentBullet1, 1, FreezeFlag1, InvertFlag1,DoubleJumpFlag1,Bullet1
    ;PlayerInput  48h , 50h  , 1Ch , 4dh, 4bh, P2Tunnel , p2x , p2y , bul2x , bul2y, CurrentWeapon2, CurrentBullet2, 0, FreezeFlag2, InvertFlag2,DoubleJumpFlag2,Bullet2
	PlayerInput  48h , 50h  , 0Ch , 4dh, 4bh, P1Tunnel , p1x , p1y , bul1x , bul1y, CurrentWeapon1, CurrentBullet1, 1, FreezeFlag1, InvertFlag1,DoubleJumpFlag1,Bullet1
	Player2Input  48h , 50h  , 0Ch , 4dh, 4bh, P2Tunnel , p2x , p2y , bul2x , bul2y, CurrentWeapon2, CurrentBullet2, 0, FreezeFlag2, InvertFlag2,DoubleJumpFlag2,Bullet2

    ; IF Escape PRESSED CLOSE
    CMP al, 27     ; escape
    JNE FLUSH
	mov p1lives, 0
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

	cmp InvertFlag1 , 1
	jne sc1
	mov dl , p1cd
	mov dh , p1cl
	mov cp1d , dh
	mov cp1l , dl
	jmp xp2
	sc1:
	mov dl , p1cd
	mov dh , p1cl
	mov cp1d , dl
	mov cp1l , dh
	xp2:
	cmp InvertFlag2 , 1
	jne sc2
	mov dl , p2cd
	mov dh , p2cl
	mov cp2d , dh
	mov cp2l , dl
	jmp nx
	sc2:
	mov dl , p2cd
	mov dh , p2cl
	mov cp2d , dl
	mov cp2l , dh
	nx:
    ;draw first pipe
    DrawPipe Pipx1 , Gap1
    ;draw second pipe
    DrawPipe Pipx2 , Gap2
    ; Draw Player 1
    DrawP p1x, p1y, m1x , m1y , cp1l , cp1d
    ; Draw Player 2
    DrawP p2x, p2y, m2x , m2y , cp2l , cp2d
	; Thrust
	DrawThrust p1x,p1y,p2x,p2y
	DrawBullet                    ; Draw bullet counter
	DrawB 2, 10, CurrentWeapon1   ; Draw bullet 1
	DrawB 298, 10, CurrentWeapon2 ; Draw bullet 2
    cmp bul1x, 0
    jz noshoot1                   ; if bullet.x = 0 don't draw
	Fire CurrentBullet1, bul1x, bul1y   ; Draw bullet 1
noshoot1:
	cmp bul2x, 0
    jz noshoot2                   ; if bullet.x = 0 don't draw
	Fire CurrentBullet2, bul2x, bul2y ; Draw bullet 1
noshoot2:
    drawhearts p1lives,p2lives
	DrawTimer timer1, InvertFlag1, timer2, InvertFlag2  ; Draw effect timer
    ret

Draw endp
;-----------------------

;------Delay Function----
Delay proc
mov di, 1
mov ah, 0
int 1Ah ; number of ticks since midnight (each 18.2 ticks approx 1 sec, so 1 tick is approx 0.05 sec ie 20 fps)
mov bx,dx ;store prev ticks
delayloop:
        mov ah, 0
        int 1Ah
        sub dx,bx ;sub newticks - prevticks
        cmp di,dx ;if 1 > (newticks - prevticks) then one tick has passed
ja delayloop


    ret

Delay endp
;---------------------
;----Update Function--
Update proc
	inc frame
    MoveB bul1x, 1
	MoveB bul2x, 0
    ; UPDATE PLAYER
    UpdatePlayer P1Tunnel, p1y
    UpdatePlayer P2Tunnel, p2y
    ;--------------
    ; GENERATE PIP 1
    GeneratePip  2,Pipx1,p1invc,Gap1, 0


    ; GENERATE PIP 2
    Generate2Pip  -2,Pipx2,p2invc,Gap2, 4
    ;------------
    ; CHECK IF PLAYER HIT THE PIP
    CheckCollision Gap1, P1Tunnel, Pipx1, p1x, p1invc, p1lives, 0, DoubleDamageFlag1
    CheckCollision Gap2, P2Tunnel, Pipx2, p2x, p2invc, p2lives, 4, DoubleDamageFlag2
	;------------
	; CHECK IF PLAYER HITTED BY BULLET
	CheckCollisionBullet p1x, p1y, bul2x, bul2y, CurrentBullet2, 1, InvertFlag1, timer1,p1lives
	CheckCollisionBullet p2x, p2y, bul1x, bul1y, CurrentBullet1, 0, InvertFlag2, timer2,p2lives
	;-----timer----
	Call UpdateTimer
	;---Update Bullet Counter---
	UpdateBullet
    ret
Update endp
;-----------------------
;------Update Timer-----
UpdateTimer proc
	dec timer1
	cmp timer1, 0
	jg NoUpdate1
	mov timer1, 0
	mov DoubleDamageFlag1, 0
	mov FreezeFlag1, 0
	mov DoubleJumpFlag1, 0
	mov InvertFlag1, 0
NoUpdate1:
	dec timer2
	cmp timer2, 0
	jg NoUpdate2
	mov timer2, 0
	mov DoubleDamageFlag2, 0
	mov FreezeFlag2, 0
	mov DoubleJumpFlag2, 0
	mov InvertFlag2, 0
NoUpdate2:
	ret
UpdateTimer endp

;=======================================================

initailize proc
mov p1y ,  2
mov bul1x , 0h   ;p1 bullet x
mov bul1y , 0h   ;p1 bullet y
mov p1lives , 5h
mov p1invc , 0h ;invincible
mov CurrentWeapon1 , 1
mov CurrentBullet1 , 1
mov timer1         , 0
mov InvertFlag1 , 0
mov DoubleJumpFlag1 , 0
mov DoubleDamageFlag1 , 0
mov FreezeFlag1 , 0
mov Bullet1, 5
mov Bullet1 + 2, 5
mov Bullet1 + 4, 5
mov Bullet1 + 6, 5
mov dl , p1cd
mov dh , p1cl
mov cp1d , dl
mov cp1l , dh
mov dl , p2cd
mov dh , p2cl
mov cp2l , dl
mov cp2l , dh
;=====================================

;============Player 2=================
mov p2y ,2
mov bul2x, 0h   ;p2 bullet x
mov bul2y, 0h   ;p2 bullet y
mov p2lives , 5h
mov p2invc , 0h ;invincible
mov CurrentWeapon2 , 1
mov CurrentBullet2 , 1
mov timer2, 0
mov InvertFlag2 , 0
mov DoubleJumpFlag2 , 0
mov DoubleDamageFlag2 , 0
mov FreezeFlag2 , 0
mov Bullet2, 5
mov Bullet2 + 2, 5
mov Bullet2 + 4, 5
mov Bullet2 + 6, 5
;======================================

mov Pipx1 , 0;pipe of first player
mov Pipx2 , 0;pipe of second player
mov Gap1 , 0;gap in first pipe
mov Gap2 , 0;gap in second pip
mov seed , 0
mov Running ,  1h
mov P1Tunnel ,   0h
mov P2Tunnel ,   0h
 mov Pipx1 ,155
    getrandom Gap1
    mov Pipx2 ,160
    ;getrandom Gap2
	mov ax, Gap1
	mov Gap2, ax
    mov Running, 1
	mov ah,0ch
    mov al,0
    int 21h
	 mov ah,0
    mov al,13h
    int 10h

;====================init chatbar==========

	call init

	ret
initailize endp



end
