EXTRN Game:far
EXTRN menu:far
EXTRN gameover:far
EXTRN p1lives:byte, p2lives:byte
PUBLIC p1cd,p2cd,p1cl,p2cl
PUBLIC currentoption,option1,optionssize
PUBLIC status
.model small 
.stack
.data

status db 0     ; 0 ==> Menu || 1 ==> ChooseColor || 2 ==> Game || 3 ==> EndGame || 4 ==> GameOver
p1cl db 0
p1cd db 0
p2cl db 0
p2cd db 0
currentoption dw 0
option1 db 14,"start new game"
option2 db 9 ,"quit game"
optionssize dw 2
.code
main proc far
	
MainLoop:	
	call menu
	cmp status, 2
	jne EndGame
	
	call Game
	mov status, 4
	
	call gameover
	cmp currentoption ,1
	je EndGame
	
	mov status, 1
	 
	jmp MainLoop

EndGame:
	mov ah, 4ch
    int 21h
main endp

end