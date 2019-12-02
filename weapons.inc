;========================================================================================
;------------Weapons Macro--------------

DrawB Macro bulx,buly,W
	Local w1,w2,w3,w4,d,inlop,outlop
	cmp W,1
     je w1 
     cmp W,2
     je w2
     cmp W,3
     je w3
     cmp W,4
     je w4
     w1:   
     lea Bx ,djcolor
     jmp d
     w2: 
     lea Bx ,hjcolor
     jmp d
     w3:  
     lea Bx ,ddcolor 
     jmp d
     w4:  
     lea Bx ,fcolor
     jmp d
     
   d:mov cx , bulx
     mov dx , buly 
     mov SI , cx  
     mov DI , dx
     add SI , 4
     add DI , 4   
     outlop:
         mov cx , bulx
         inlop:
         mov al,[bx]
         mov ah,0ch 
         int 10h   
         inc cx 
         inc Bx
         cmp cx,SI
         jl inlop 
     inc dx  
     cmp dx , DI
     jl outlop
ENDM DrawB
;========================================================================================

;========================================================================================
ClearB Macro bulx, buly
	Local olop,ilop
	 mov cx , bulx
     mov dx , buly 
     mov SI , cx  
     mov DI , dx
     add SI , 4
     add DI , 4   
     olop:
         mov cx , bulx
         inlop:
         mov al,00
         mov ah,0ch 
         int 10h   
         inc cx 
         cmp cx,SI
         jl ilop 
     inc dx  
     cmp dx , DI
     jl outlop
	
ENDM ClearB
