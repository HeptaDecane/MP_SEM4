section .data
    msg1: db "Enter a number: "
    len_msg1: equ $-msg1
    msg2: db "Entered Number: "
    len_msg2: equ $-msg2

section .bss
    num: resb 10

section .text
    global _start
    _start:
        mov eax,4
        mov ebx,1
        mov ecx,msg1
        mov edx,len_msg1
        int 80h

        mov eax,3
        mov ebx,0
        mov ecx,num
        mov edx,10
        int 80h

        mov eax,4
        mov ebx,1
        mov ecx,msg2
        mov edx,len_msg2
        int 80h

        mov eax,4
        mov ebx,1
        mov ecx,num
        mov edx,10
        int 0x80

        mov eax,1
        mov ebx,0
        int 80h
