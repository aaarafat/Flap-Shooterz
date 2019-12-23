EXTRN Game:far
EXTRN menu:far
EXTRN gameover:far
EXTRN selname:far
EXTRN chatproc:far
EXTRN p1lives:byte, p2lives:byte,p1name:byte
EXTRN waitproc:far
EXTRN getp2name:far
PUBLIC p1cd,p2cd,p1cl,p2cl,p2name
PUBLIC currentoption,option1,optionssize
PUBLIC status
public p2status
public lvlOption
.model small
.stack
.data
recivecount db 16
sendcount db 16
status db -1    ; -2 ==> chat || -1 ==> SelectName || 0 ==> Menu || 1 ==> ChooseColor || 2 ==> Game || 3 ==> EndGame || 4 ==> GameOver
p2status db -1
p1cl db 0
p1cd db 0
p2cl db 0
p2cd db 0
currentoption dw 0
option1 db 14,"START NEW GAME"
option2 db 9 ,"QUIT GAME"

optionssize dw 2
lvlOption   dw 0     ; 1 ==> lv1 , 2 ==> lv2
p2name db 16 dup('$') ;temporary for phase 1
.code
main proc far

MainLoop:

	call selname
	cmp status, 0
	jne EndGame

	
MenuLB:
	call menu

	cmp status, -2
	je ChatLB
	cmp status, 2
	je GameLB
	cmp status, 0
	je MenuLB
	jne EndGame

ChatLB:
	call waitproc
	cmp status, 0
	je MenuLB
	cmp status, -2
	jne EndGame
	call getp2name
	call chatproc

	cmp status, 0
	je MenuLB
	cmp status, 2
	jne EndGame

GameLB:
	call waitproc
	cmp status, 0
	je MenuLB
	call xchgcolors
	;cmp status, 2
	;je EndGame

	call Game
	mov status, 4

	call gameover
	cmp currentoption, 1
	je EndGame

	mov status, 1

	jmp MainLoop

EndGame:
	mov ah, 4ch
    int 21h
main endp


xchgcolors proc

	repsend1:
	mov dx, 3fdh
	in al, dx
	test al, 00100000b
	jz repsend1

	mov dx , 3F8H ; Transmit data register
	mov al, p1cl
	out dx , al

	reprec1:
	mov dx , 3FDH ; Line Status Register
	in al , dx
	test al , 1
	jz reprec1

	mov dx , 03F8H
	in al , dx
	mov p2cl, al


	repsend2:
	mov dx, 3fdh
	in al, dx
	test al, 00100000b
	jz repsend2

	mov dx , 3F8H ; Transmit data register
	mov al, p1cd
	out dx , al

	reprec2:
	mov dx , 3FDH ; Line Status Register
	in al , dx
	test al , 1
	jz reprec2

	mov dx , 03F8H
	in al , dx
	mov p2cd, al

	

ret 
xchgcolors endp 



end main
