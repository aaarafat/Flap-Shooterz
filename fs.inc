


; draw half the photo as it so large 
DrawHalfMM Macro x,y,color1,color2,off 
		local ilop , olop , skip , c1 ,d
		  mov cx , x
          mov dx , y
          lea SI , off  ;load the offest 
          mov msx , cx
          mov msy , dx
          add msx , 65
          add msy , 50
     olop:
         mov cx , x 
     ilop:
         mov al,[SI] 
		 ;representation of the 2 colors 
		 cmp al , 2
		 jl c1
		 mov al , color2
		 jmp d
         c1:and al,al
		 jz skip
         mov al , color1
         d:mov ah,0ch 
         int 10h 
         skip: inc SI
         inc cx
         cmp cx , msx
         jl ilop
         
         inc dx
         cmp dx , msy
         jle olop
		 ENDM