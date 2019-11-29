shoot MACRO sxpos, sypos, slen, swid, color
local colcount
mov cx, sxpos  ;col
mov dx, sypos  ;row
mov ah, 0ch ; put pixel
mov al, color
mov si, sxpos
mov di, sypos
add si, swid
add di, slen

colcount:
inc cx
int 10h
cmp cx, si
JNE colcount

mov cx, sxpos  ; reset to start of col
inc dx      ;next row
cmp dx, di
JNE colcount
ENDM shoot