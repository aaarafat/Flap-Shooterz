include weapons.inc
.model small
.stack
.data
b1x     dw   50      ; left upper cornder 
b1y     dw   50 
Weapon1 dw   1        
djcolor   db   05h,05h,05h,05h,0dh,0dh,0dh,0dh,0dh,0dh,0dh,0dh,05h,05h,05h,05h  
hjcolor   db   00h,0ah,02h,00h,0ah,02h,02h,02h,02h,02h,02h,0ah,00h,02h,0ah,00h
ddcolor   db   04h,00h,00h,04h,00h,0ch,0ch,00h,00h,0ch,0ch,00h,04h,00h,00h,04h
fcolor    db   0fh,03h,03h,0fh,03h,0fh,0fh,03h,03h,0fh,0fh,03h,0fh,00h,03h,0fh  
.code
main proc far 
    mov ax,@data
    mov ds,ax 
    ; change graphics mode
    mov ah,0
    mov al,13h
    int 10h  
    
    DrawB  b1x,b1y,Weapon1
    add b1y, 10
    inc Weapon1   
    DrawB  b1x,b1y,Weapon1
     add b1y, 10
    inc Weapon1 
    DrawB  b1x,b1y,Weapon1
     add b1y, 10
    inc Weapon1 
    DrawB  b1x,b1y,Weapon1
    
    
	mov ah, 4ch
	int 21h
	
main endp 

end main