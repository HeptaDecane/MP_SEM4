%macro print 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro exit 0
    mov eax, 1
    mov ebx, 0
    int 80h
%endmacro

section .data
    msg: db "Sum = "
    len: equ $-msg
    newLine: db 10
    arr: dd 112,-113,-9,1,2,3,4,7,1
    n: equ 9

section .bss
    sum: resb 1
    digit: resb 1

section .text
    global _start
    _start:

        mov esi,arr
        mov edi,n
        mov eax,0

        begin:
        add eax,[esi]

        update:
        add esi,4
        dec edi
        jnz begin

        mov [sum],eax

        print msg,len

        mov eax,[sum]
        call printEAXdigit

        print newLine,1

        exit

printEAXdigit:
    add eax,30h
    mov [digit],eax
    mov eax, 4
    mov ebx, 1
    mov ecx, digit
    mov edx,1
    int 80h
    ret
