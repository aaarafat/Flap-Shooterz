shoot MACRO sxpos, sypos, slen, swid, color
local colcount
local Continue
mov cx, sxpos  ;col
mov dx, sypos  ;row
mov ah, 0ch ; put pixel
mov al, color
mov si, sxpos
mov di, sypos
add si, swid
add di, slen

colcount:
cmp cx, 320
jge Continue
int 10h
inc cx
cmp cx, si
JNE colcount
Continue:
mov cx, sxpos  ; reset to start of col
inc dx      ;next row
cmp dx, di
JNE colcount
ENDM shoot