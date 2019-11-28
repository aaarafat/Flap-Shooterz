include barrier.inc
.model small
.data
plen dw 40
px   dw 50
py   dw 20
mx   dw 20
my   dw 0
random dw 0
seed dw 40

.code
main proc far
    mov ax,@data
   mov ds,ax
   mov al,012h
   mov ah,0
   int 10h
   ;get random number
   getrandom seed random
   mov mx,360
loop4:      
    cmp mx,-1
	;if mx smaller than 0 wrap
	jnz nowrap 
		mov mx,360
    nowrap:
    drawbarrier
    drawgap random  
	;delay 0.1 second
	MOV     CX, 01H
    MOV     DX, 086A0H
    MOV     AH, 086H
    INT     15H
    deleteline
    dec mx
	;take input if == 'a' stop
    mov ah,01h
    mov al,1
    int 16h  
	jz loop4
        cmp al,'a'
        jz finish
        mov ah,0ch
        mov al,0
        int 21h 
    jmp loop4
finish:
    mov ah ,04ch
    int 21h
    endp main 
    
end main
