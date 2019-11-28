include p1m.inc 
.model small
.stack
.data
plen   equ  20      ; height and width of player
p1x    dw   50      ; left upper cornder 
p1y    dw   0   
m1x    dw   0       ; right bottom corner 
m1y    dw   0  
p1cl   db   09h     ; p1 body color
p1cd   db   01h     ; p1 link color

.code
main proc far 
    mov ax,@data
    mov ds,ax 
    ; change graphics mode
    mov ah,0
    mov al,13h
    int 10h
    
    DrawP1 p1x, p1y, plen, m1x , m1y , p1cl , p1cd
    ClearP1 p1x, 10, plen, m1x , m1y

	mov ah, 4ch
	int 21h
main endp 
end main