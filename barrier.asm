include barrier.inc
.model small
.stack 64
.data
plen dw 40
px   dw 50
py   dw 20
mx   dw 20
my   dw 0
pipx dw 0
tunnel dw 0
Running dw 1
.code
main proc far 
    mov ax,@data
    mov ds,ax 
    ; change graphics mode
    mov ah,0
    mov al,13h
    int 10h
    
    ;get random number
   getrandom  tunnel
   mov pipx,200
GameLoop:    
  
    Call Clear
  cmp pipx,-1
	;if mx smaller than 0 wrap
	jnz nowrap 
		mov pipx,200
    ; Clear
	nowrap:		
     dec pipx
	; Get Input
	call GetInput
    ; Draw
    Call Draw
    ; Delay
    Call Delay
        mov ah,01h
    mov al,1
    int 16h  
	cmp Running,0
    jnz GameLoop
finish:	
	mov ah, 4ch
	int 21h
	
main endp


;------Clear Screen----- 
Clear proc
    DeletePipe pipx ,tunnel
    ret
Clear endp 
;-----------------------
    
;------Get Input----- 
GetInput proc
    mov ah, 1
    int 16h   ; Get Key Pressed
    jz Return ; If no Key Pressed Return
    mov Running, 0  ; Else Exit 
    jmp Return
    ;------------      
Return:
    ; Flush Keyboard Buffer
    mov ah,0ch
    mov al,0
    int 21h
    ret
GetInput endp 
;-----------------------   
    
;------Draw Function---- 
Draw proc  
    ; Draw Player 1
    	 DrawPipe pipx , tunnel
  
    ret
Draw endp
;-----------------------
                           
;------Delay Function---- 
Delay proc  
    mov ah, 86h
    mov cx, 1h
    mov dx, 86A0h
    int 15h
    ret

Delay endp
;----------------------- 
end main