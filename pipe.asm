include pipe.inc
.model small
.stack
.data
pipx dw 159
tunnel dw 24
;=======================
.code  



main proc far   
   
 
    mov ax,@data
    mov ds,ax 
    ; change graphics mode
    mov ah,0
    mov al,13h  
    int 10h
         
    DrawPipe pipx , tunnel     
     
          
          
          

    

	mov ah, 4ch
	int 21h  
main endp 

end main 