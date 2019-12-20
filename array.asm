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
    msg: db "Array Elments: "
    len: equ $-msg
    space: db " "
    newLine: db 10
    arr: dd 5,7,3,9,2,4
    n: equ 6

section .bss
    digit: resb 1

section .text
    global _start
    _start:
        mov esi,arr                     ;# esi holding the base Address of Array
        mov edi,n                       ;# edi holding count af Array Elments

        print msg,len

        ;# Beginning of the Loop
        begin:
        mov eax,[esi]
        call printEAXDigit
        print space,1

        update:
        add esi,4                       ;# inc esi by 4bytes to point to next array element (arr is of type doubleword-dd)
        dec edi                         ;# decrement count;
        jnz begin                       ;# id count!=0 goto 'begin'
        ;# End of the Loop

        print newLine,1

        exit

printEAXDigit:
    add eax,30h
    mov [digit],eax
    mov eax, 4
    mov ebx, 1
    mov ecx, digit
    mov edx,1
    int 80h
    ret



;   Note:
;      Use esi and edi registers to traverse array,
;        because eax and ebx registers are updated during system calls.
