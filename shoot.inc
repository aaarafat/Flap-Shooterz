shoot MACRO sxpos, sypos, slen, swidquart, color1, color2, color3
local colcount1
local Continue1
local colcount2
local Continue2
local colcount3
local Continue3

mov cx, sxpos  ;col
mov dx, sypos  ;row
mov ah, 0ch ; put pixel
mov al, color1
mov si, sxpos
mov di, sypos
add si, swidquart
add si, swidquart
add di, slen
mov bp, cx

colcount1:
cmp cx, 320
jge Continue1
int 10h
inc cx
cmp cx, si
JNE colcount1
Continue1:
mov cx, bp  ; reset to start of col
inc dx      ;next row
cmp dx, di
JNE colcount1

mov cx, si
add si, swidquart
mov al, color2
mov dx, sypos
mov bp, cx


colcount2:
cmp cx, 320
jge Continue2
int 10h
inc cx
cmp cx, si
JNE colcount2
Continue2:
mov cx, bp  ; reset to start of col
inc dx      ;next row
cmp dx, di
JNE colcount2

mov cx, si
add si, swidquart
mov al, color3
mov dx, sypos
mov bp, cx

colcount3:
cmp cx, 320
jge Continue3
int 10h
inc cx
cmp cx, si
JNE colcount3
Continue3:
mov cx, bp  ; reset to start of col
inc dx      ;next row
cmp dx, di
JNE colcount3
ENDM shoot