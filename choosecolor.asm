EXTRN p1cl:byte    
EXTRN p1cd:byte       
EXTRN p2cl:byte     
EXTRN p2cd:byte       
public choosecolor
include p1m.inc
.model small 
.stack 64 
.data
plen equ 20             
colorssize equ 6
colorssize2 equ 5
colors db 9,10,11,12,13,7
backcolors db   1,2,3,4,5,8
currentcolor1 dw 0 
currentcolor2 dw 0
colorpicker1  db 32,08,10,31,10,08,10,10,10,30,10,08,32 
colorpicker2  db 31,08,10,32,10,08,10,10,10,32,10,08,30           
choosecolor1 db "PLAYER1"
choosecolor2 db "PlAYER2" 
count db 1
p1x dw 154
p1y dw 41
m1x dw 0
m1y dw 0   
p2x dw 154
p2y dw 96
m2x dw 0
m2y dw 0 
.code
choosecolor proc far
    mov ax,@data
    mov ds,ax
	mov ah,0
	mov al,13h
	int 10h
	uiloop:             
    mov ah,1
    int 16h 
    jz nopress
    cmp ah,048h
    jz up
    cmp ah,050h
    jz down
	cmp ah,01ch   
    jnz nolongjump
    jmp quit
    nolongjump:
    jmp press
    up:
    dec currentcolor1
    jns press
    mov currentcolor1,colorssize-1
    jmp press
    down:
    inc currentcolor1
    jmp press
    press:
    mov ah,0ch
    mov al,0
    int 21h
	;mod to wrap
    mov ax,currentcolor1
    mov dx,colorssize
    div dl
    mov al,0            
    xchg al,ah
    mov currentcolor1,ax
    nopress:        
	;init for int 10h
    mov dh, 6;row
	mov bh,0 ;Page 0
    lea bp, choosecolor1
    push ds;to make es equal to ds
    pop es;int 10h es:bp 
    mov bl,0fh
    mov al, 1
    mov cx, 7
    ;set cursor to middel of screen
    ;mov dl,40
	;sub dl,cl
	;shr dl,1
	mov dl,10
	mov ah, 13h
    int 10h
    lea si,colors
    add si,currentcolor1
    mov ax,6 
    add si,ax
    mov bl,[si]
    mov p1cd,bl
    sub si,ax
	mov bl,[si]
    mov p1cl,bl
    
	mov dh, 3;row 
	cmp count,1
	je float
	jne float2  
	float:
    mov bp,offset colorpicker1
    jmp ot
    float2:
    mov bp,offset colorpicker2
    ot: 
    mov cx ,13
    xor count,1
    mov al, 1

    ;set cursor to middel of screen
    mov dl,20
	mov ah, 13h
    int 10h
    
    ClearP p1x, p1y, m1x , m1y
    DrawP p1x, p1y, m1x , m1y , p1cl , p1cd
    mov di, 1 
    mov cx, 7      ;HIGH WORD.
    mov dx, 0A120h ;LOW WORD.
     mov ah, 86h    ;WAIT.
    int 15h
    

	jmp uiloop 
	quit:
	mov ah,0ch
    mov al,0
    int 21h
	lea si,colors
    add si,currentcolor1
    mov bl,[si]
    mov al,colors+colorssize2
    mov colors+colorssize2,bl
    mov [si],al
    lea si,backcolors
    add si,currentcolor1
    mov bl,[si]
    mov al,backcolors+colorssize2
    mov backcolors+colorssize2,bl
    mov [si],al
	uiloop2:             
    mov ah,1
    int 16h 
    jz nopress2
    cmp ah,048h
    jz up2
    cmp ah,050h
    jz down2
	cmp ah,01ch   
    jnz nolongjump2
    jmp quit2
    nolongjump2:
    jmp press2
    up2:
    dec currentcolor2
    jns press2
    mov currentcolor2,colorssize-2
    jmp press2
    down2:
    inc currentcolor2
    jmp press2
    press2:
    mov ah,0ch
    mov al,0
    int 21h
	;mod to wrap
    mov ax,currentcolor2
    mov dx,colorssize2
    div dl
    mov al,0            
    xchg al,ah
    mov currentcolor2,ax
    nopress2:        
	;init for int 10h
    mov dh,13 ;row
	mov bh,0 ;Page 0
    lea bp, choosecolor2
    push ds;to make es equal to ds
    pop es;int 10h es:bp 
    mov bl,0fh
    mov al, 1
    mov cx, 7
    ;set cursor to middel of screen
    ;mov dl,40
	;sub dl,cl
	;shr dl,1
	mov dl,10
	mov ah, 13h
    int 10h
    lea si,colors
    add si,currentcolor2
    mov ax,6 
    add si,ax
    mov bl,[si]
    mov p2cd,bl
    sub si,ax
	mov bl,[si]
    mov p2cl,bl
    
	mov dh, 10;row 
	cmp count,1
	je float1
	jne float12  
	float1:
    mov bp,offset colorpicker1
    jmp ot12
    float12:
    mov bp,offset colorpicker2
    ot12: 
    mov cx ,13
    xor count,1
    mov al, 1

    ;set cursor to middel of screen
    mov dl,20
	mov ah, 13h
    int 10h
    
    ClearP p2x, p2y, m2x , m2y
    DrawP p2x, p2y, m2x , m2y , p2cl , p2cd
    mov di, 1 
    mov cx, 7      ;HIGH WORD.
    mov dx, 0A120h ;LOW WORD.
     mov ah, 86h    ;WAIT.
    int 15h
    

	jmp uiloop2 
	quit2:
	mov ah,0
	mov al,13h
	int 10h
	ret
   choosecolor endp  
end