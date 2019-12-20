EXTRN Game:far
EXTRN menu:far
EXTRN gameover:far
EXTRN selname:far
EXTRN chatproc:far
EXTRN p1lives:byte, p2lives:byte
PUBLIC p1cd,p2cd,p1cl,p2cl,p2name
PUBLIC currentoption,option1,optionssize
PUBLIC status
.model small
.stack
.data

status db -1    ; -2 ==> chat || -1 ==> SelectName || 0 ==> Menu || 1 ==> ChooseColor || 2 ==> Game || 3 ==> EndGame || 4 ==> GameOver
p1cl db 0
p1cd db 0
p2cl db 0
p2cd db 0
currentoption dw 0
option1 db 14,"START NEW GAME"
option2 db 9 ,"QUIT GAME"
optionssize dw 2
p2name db 7,'PLAYER2' ;temporary for phase 1
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
	jne EndGame

ChatLB:
	call chatproc
	cmp status, 0
	je MenuLB
	cmp status, 2
	jne EndGame

GameLB:
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

end
