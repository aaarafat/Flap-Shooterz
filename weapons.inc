;========================================================================================
;------------Weapons Macro--------------

DrawB Macro bulx,buly,W
	Local w1,w2,w3,w4,d,inlop,outlop,finish
	cmp W,1
     je w1 
     cmp W,2
     je w2
     cmp W,3
     je w3
     cmp W,4
     je w4
     w1:   
     lea Bx ,djcolor
     jmp d
     w2: 
     lea Bx ,hjcolor
     jmp d
     w3:  
     lea Bx ,ddcolor 
     jmp d
     w4:  
     lea Bx ,fcolor
     jmp d
     
   d:mov cx , bulx
     mov dx , buly 
     mov SI , cx  
     mov DI , dx
     add SI , 4
     add DI , 4   
     outlop:
		 cmp dx, ScreenWidth
		 jge finish
         mov cx , bulx
         inlop:
         mov al,[bx]
         mov ah,0ch 
         int 10h   
         inc cx 
         inc Bx
         cmp cx,SI
         jl inlop 
     inc dx  
     cmp dx , DI
     jl outlop
    finish:
ENDM DrawB
;========================================================================================

;========================================================================================
ClearB Macro bulx, buly
	Local olop,ilop,finish
	 mov cx , bulx
     mov dx , buly 
     mov SI , cx  
     mov DI , dx
     add SI , 4
     add DI , 4   
     olop:
         mov cx , bulx
		 cmp dx, ScreenWidth
		 jge finish
         ilop:
         mov al,00
         mov ah,0ch 
         int 10h   
         inc cx 
         cmp cx,SI
         jl ilop 
     inc dx  
     cmp dx , DI
     jl olop
	finish:
ENDM ClearB
;========================================================================================

;========================================================================================
Fire MACRO W, bulx, buly
	LOCAL finish
	cmp bulx, 0     ; if bullet.x = 0 don't draw
	je finish
	DrawB bulx, buly, W
finish:
ENDM Fire
;========================================================================================

;========================================================================================
MoveB MACRO bulx, IsPlayer1
    LOCAL noupdate, PLAYER2
    cmp bulx, 0 ;check if there's a shoot
    jz noupdate
	mov ax, IsPlayer1
	cmp ax, 0     
	je PLAYER2
    add bulx, 8 ;move the shoot
    cmp bulx, ScreenWidth ;if we reached to the end of screen
    jb noupdate
    mov bulx, 0
PLAYER2:
	sub bulx, 8
	cmp bulx, 0
	jg noupdate
	mov bulx, 0
noupdate:

ENDM MoveB
;========================================================================================

;========================================================================================
DrawBullet Macro	
	push es
	mov ax, ds
	mov es, ax

	add CurrentBulletCount1, '0'
	add CurrentBulletCount2, '0'
	;---PLAYER 1---;
	;DrawB 0, 10, CurrentWeapon1
    mov ah,13h ;Display
	mov al, 0h ;text mode
    mov bh,0 ;Page 0
	mov cx, 2 ;string length
    mov bl,p1cl ;color
	mov dh, 1h ; row
	mov dl, 1h ; col
	lea bp, Bulletstr1
    int 10h
	;--------------;
	
	;---PLAYER 2---;
	mov ah,13h ;Display
	mov al, 0h ;text mode
    mov bh,0 ;Page 0
	mov cx, 2 ;string length
    mov bl,p2cl ;color
	mov dh, 1h
	mov dl, 38
	lea bp, Bulletstr2
    int 10h
	;DrawB 308, 10, CurrentWeapon2
	;--------------;
	pop es
	sub CurrentBulletCount1, '0'
	sub CurrentBulletCount2, '0'
endm DrawBullet
;========================================================================================

;========================================================================================
ClearBullet Macro	
	; move cursor
    mov ah,2
    mov dh, 1
	mov dl, 0
    mov bh, 0
    int 10h
	;---PLAYER 1---;
    mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al, ' ' ;space
    mov cl, 3
    mov ch, 0
    mov bl,09h
    int 10h
	;--------------;

	; move cursor
	mov ah, 1
	mov dl,37
	mov dh,02h
	mov bh,0
	int 10h
	;---PLAYER 2---;
	mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al, ' ' ;space
    mov cl, 3
    mov ch, 0
    mov bl,04h
    int 10h
	;--------------;
endm ClearBullet
;========================================================================================

;========================================================================================
UpdateBullet macro
	;---PLAYER 1---;
	mov si, offset Bullet1
	mov ax, 0
	mov al , CurrentWeapon1
	dec ax           ; as Current weapon starts from 1
	mov bx, 2
	mul bl           
	add si, ax
	mov ax, [si]
	mov CurrentBulletCount1, al
	;--------------;
	
	;---PLAYER 2---;
	mov si, offset Bullet2
	mov ax, 0
	mov al , CurrentWeapon2
	dec ax
	mov bx, 2
	mul bl
	add si, ax
	mov ax, [si]
	mov CurrentBulletCount2, al
	;--------------;
	
endm UpdateBullet
;========================================================================================