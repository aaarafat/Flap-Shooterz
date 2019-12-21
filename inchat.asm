public sendproc, recproc, init
EXTRN Running:byte
.MODEL SMALL
.STACK 64
.DATA
upperx db 0
uppery EQU 20
lowerx db 0
lowery EQU 24
value db 0
.CODE
init proc far
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
	mov bl, 0
	mov bh, 0FFh      ; normal video attribute
	mov ch,21       ; upper left Y
	mov cl,0        ; upper left X
	mov dh,21     ; lower right Y
	mov dl,39      ; lower right X
	int 10h
	mov upperx, 0
	mov lowerx, 0

init endp
sendproc	PROC FAR
		mov ax, @DATA
		mov ds, ax

		cmp upperx, 39
		jnz nolimitsend
		call supper
		mov upperx, 0

	nolimitsend:
		;get input from KB
		mov ah, 1
		int 16h
		mov value, al

		;move cursor
		mov ah, 2
		mov dl, upperx
		mov dh, uppery
		mov bh, 0
		int 10h
		inc upperx

		; if value = backspace
		cmp value, 8
		je BKSP1

		;print char
		mov ah, 2
		mov dl, value
		int 21h ;print char
		jmp BKSPCont
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
		je BKSPCont
		dec upperx
	BKSPCont:
		;scroll if upperx == 79 (right end of the window)
		cmp upperx, 40
		jnz contsend
		call supper
		mov upperx, 0
		jmp contsend

	contsend:
		;Check that Transmitter Holding Register is Empty
		mov dx, 3fdh
		in al, dx
		test al, 00100000b
		jz return ;if not empty go to save before recieving (No sending)

		;If empty put the VALUE in Transmit data register
		mov dx , 3F8H ; Transmit data register
		mov al, value
		out dx , al

		cmp value, 27
		jnz NotEscape
		mov Running, 0
		jmp return

	NotEscape:
		cmp value, 13 ;new Line
		jnz return
		call supper
		mov upperx, 0
	return:
	ret
sendproc endp

recproc proc FAR
;scroll if lowerx == 79 (right end of the window)
		cmp lowerx, 39
		jnz nolimitrec
		call slower
		mov lowerx, 0

	nolimitrec:
		;Check that Data is Ready
		mov dx , 3FDH ; Line Status Register
		in al , dx
		test al , 1
		jz close

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
		cmp lowerx, 40
		jnz contrec
		call slower
		mov lowerx, 0

	contrec:
		cmp value, 27 ;escape
		jnz NotEscapeRec
		mov Running, 0
		jmp close
	NotEscapeRec:
		cmp value, 13 ;new Line
		jnz close
		call slower
		mov lowerx, 0
	close:
	ret
recproc endp

supper proc
mov ah,6 ; function 6
mov al,1 ; scroll by 1 line
mov bl, 0
mov bh,0      ; normal video attribute
mov ch,18       ; upper left Y
mov cl,0        ; upper left X
mov dh,20     ; lower right Y
mov dl,39      ; lower right X
int 10h

ret
supper endp

slower proc
mov ah,6 ; function 6
mov al,1 ; scroll by 1 line
mov bl, 0
mov bh,0     ; normal video attribute
mov ch,22       ; upper left Y
mov cl,0        ; upper left X
mov dh,24     ; lower right Y
mov dl,39      ; lower right X
int 10h

ret
slower endp

		end
