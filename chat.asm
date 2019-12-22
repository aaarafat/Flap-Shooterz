EXTRN status:byte
EXTRN p1name:byte 
public chatproc
.MODEL SMALL
.STACK 64
.DATA
upperx db 0
uppery EQU 12
lowerx db 0
lowery EQU 23
value db 0
.CODE
chatproc proc
		mov ax, @DATA
		mov ds, ax

		mov ah,0
		mov al,3h
		int 10h

		mov dx,3fbh 			; Line Control Register
		mov al,10000000b		;Set Divisor Latch Access Bit
		out dx,al				;Out it

		mov dx,3f8h
		mov al,0ch
		out dx,al

		mov dx,3f9h
		mov al,00h
		out dx,al

		mov dx,3fbh
		mov al,00011011b
		out dx, al


		mov ah,6       ; function 6
		mov al,0       ; clear
		mov bh,4Fh      ; normal video attribute
		mov ch,0       ; upper left Y
		mov cl,0        ; upper left X
		mov dh,12     ; lower right Y
		mov dl,79      ; lower right X
		int 10h

		mov ah,6       ; function 6
		mov al,0       ; clear
		mov bh,7      ; normal video attribute
		mov ch,13       ; upper left Y
		mov cl,0        ; upper left X
		mov dh,24     ; lower right Y
		mov dl,79      ; lower right X
		int 10h

		mov ah, 2
		mov dl, 0
		mov dh, 0
		mov bh, 0
		int 10h
		call printname
		call transmit

	ret
chatproc endp


;TODO Scroll one of the halves of the screen by one line
scrollupper proc
mov ah,6 ; function 6
mov al,1 ; scroll by 1 line
mov bh,4Fh      ; normal video attribute
mov ch,0       ; upper left Y
mov cl,0        ; upper left X
mov dh,12     ; lower right Y
mov dl,79      ; lower right X
int 10h

ret
scrollupper endp

scrolllower proc
mov ah,6 ; function 6
mov al,1 ; scroll by 1 line
mov bh,7      ; normal video attribute
mov ch,13       ; upper left Y
mov cl,0        ; upper left X
mov dh,24     ; lower right Y
mov dl,79      ; lower right X
int 10h

ret
scrolllower endp
;print player name
printname proc 
mov al, 0
mov bh, 0;page nubmer
mov bl,04fh
mov cl, p1name ;  message size.
mov ch,0
push ds
pop es
mov dl,upperx
mov dh,uppery
mov bp,offset p1name+1
mov ah, 13h
int 10h
mov upperx,cl
;mov cursor
mov ah, 2
mov dl, upperx
mov dh, 12
mov bh, 0
int 10h
mov ah, 2
mov dl, ':'
int 21h ;print char
inc upperx	
ret
printname endp

transmit proc
	send:
	;get input from KB
	mov ah, 1
	int 16h
	jz ShortReceive ;if no key pressed
	mov value, al
	cmp value, 27 ;escape
	jnz noShortclose
	jmp contsend
	noShortclose:
	;move cursor
	mov ah, 2
	mov dl, upperx
	mov dh, uppery
	mov bh, 0
	int 10h
	inc upperx
	mov al, p1name
	add al,2
	cmp upperx,al
	je noBKSP
	; if value = backspace
	cmp value, 8
	je BKSP1
	noBKSP:
	;print char
	mov ah, 2
	mov dl, value
	int 21h ;print char
	jmp Flush1
BKSP1:
	dec upperx
	; print space
	mov ah, 2
	mov dl, 8
	int 21h ;print char
	mov dl, ' '
	int 21h ;print char
	mov dl, 8
	int 21h ;print char
	cmp upperx, 0
	je Flush1
	dec upperx
Flush1:
	;flush KB
	mov ah, 0
	int 16h

	;scroll if upperx == 79 (right end of the window)
	cmp upperx, 79
	jnz contsend
	call scrollupper
	mov upperx, 0
	call printname
	jmp contsend
ShortReceive:
	jmp receive
contsend:
	;Check that Transmitter Holding Register is Empty
	mov dx, 3fdh
	in al, dx
	test al, 00100000b
	jz receive ;if not empty go to save before recieving (No sending)

	;If empty put the VALUE in Transmit data register
	mov dx , 3F8H ; Transmit data register
	mov al, value
	out dx , al
	cmp al, 27
	jz Shortclose
	
	cmp value, 13 ;new Line
	jnz receive
	call scrollupper
	mov upperx, 0
	call printname
	receive:
	;Check that Data is Ready
	mov dx , 3FDH ; Line Status Register
	in al , dx
	test al , 1
	jz Shortsend ;Not Ready

	;If Ready read the VALUE in Receive data register
	mov dx , 03F8H
	in al , dx
	mov value, al

	;move cursor
	mov ah, 2
	mov dl, lowerx
	mov dh, lowery
	mov bh, 0
	int 10h
	inc lowerx

	; if value = BKSP
	cmp value, 8
	je BKSP2

	mov ah, 2
	mov dl, value
	int 21h ;print char
	jmp SKIP
Shortclose:
	jmp close
Shortsend:
	jmp send
BKSP2:
	dec lowerx
	; print space
	mov ah, 2
	mov dl, 8
	int 21h ;print char
	mov dl, ' '
	int 21h ;print char
	mov dl, 8
	int 21h ;print char
	cmp lowerx, 0
	je SKIP
	dec lowerx

SKIP:
	;scroll if lowerx == 79 (right end of the window)
	cmp lowerx, 79
	jnz contrec
	call scrolllower
	mov lowerx, 0

contrec:
	cmp value, 27 ;escape
	jz close
	cmp value, 13 ;new Line
	jnz lop
	call scrolllower
	mov lowerx, 0


lop:
	jmp send


	close:
	mov status, 0
	mov upperx, 0
	mov lowerx, 0
	;flush KB
	mov ah, 0
	int 16h
	mov ah,0
	mov al,13h
	int 10h
	ret
transmit endp
		end
