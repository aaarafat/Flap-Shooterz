EXTRN status:byte
public p1name
public selname
.model small
.stack
.data
org 0h
esckey equ 27
enterkey equ 13
bckspace equ 8
p1name db 0, 16 dup('$')

str1 db 'Please enter your name:$'
str2 db 'Press Enter to continue$'
.code
selname proc far
    mov ax, @data
    mov ds, ax

    ;clear screen
    mov ah,0
    mov al,3h
    int 10h

    ;moving cursor to print first string
    mov ah, 2
    mov dl, 26
    mov dh, 11
    mov bh, 0
    int 10h

    mov ah, 9
    lea dx, str1
    int 21h

    ;moving cursor to print second string
    mov ah, 2
    mov dl, 26
    mov dh, 13
    mov bh, 0
    int 10h

    mov ah, 9
    lea dx, str2
    int 21h

    ;moving cursor for the input
    mov ah, 2
    mov dl, 26
    mov dh, 12
    mov bh, 0
    int 10h

    ;di points to the input location
    lea di, p1name
    inc di
    push ds
    pop es ;need es to point to ds to use stosb command

    ;status = 0 (means next stage is main menu)
    mov status, 0

    ;check keyboard input
    CHECK:
    mov ah,1
    int 16h
    jz CHECK

    ;flush keyboard
    mov ah,0
    int 16h

    cmp al, bckspace
    jnz notbckspace
    cmp p1name, 0
    jz notbckspace

    mov ah,2
    mov dl, bckspace
    int 21h

    mov dl, ' '
    int 21h

    mov dl, bckspace
    int 21h
    dec p1name
    dec di


    notbckspace:
    cmp al, esckey
    jz exit

    cmp al, enterkey
    jnz notenter
    ;cant enter empty string
    cmp p1name, 0
    jnz finish

    notenter:
    cmp p1name, 0
    jz firstletter

    ;name consists of only printable ascii (between 32, 126)
    cmp al, 32
    jl CHECK
    cmp al, 126
    jg CHECK

    ;from al to es:[DI]
    stosb
    inc p1name

    ;print al to screen
    mov ah,2
    mov dl, al
    int 21h

    ;if name length is 15 -> go to main menu
    cmp p1name, 15
    jnz CHECK
    jmp finish

    ;name should start with a letter (No digits or special characters).
    ;first letter between (65, 90) or (97, 122)
    firstletter:
    cmp al, 65
    jl CHECK
    cmp al, 90
    jle pass

    cmp al, 97
    jl CHECK
    cmp al, 122
    jg CHECK
    pass:
    stosb
    inc p1name

    mov ah,2
    mov dl, al
    int 21h

    ;if name length is 15 -> go to main menu
    cmp p1name, 15
    jnz CHECK
    jmp finish

    exit:
    mov status, 5 ;status != 0 means exit
    finish:
    ret
selname endp
end
