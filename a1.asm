;# Macro for Printing a String
%macro print 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

;# Macro for exit call
%macro exit 0
    mov eax, 1
    mov ebx, 0
    int 80h
%endmacro

section .data
    pmsg: db "The Count of Positive Numbers: "
    plen: equ $-pmsg
    nmsg: db "The Count of Negative Numbers: "
    nlen: equ $-nmsg
    newLine: db 10
    arr: dd 600,-500,432,-35,2,1
    n: equ 6

section .bss
    pcount: resb 1
    ncount: resb 1
    digit: resb 1

section .text
    global _start
    _start:

        mov esi,arr
        mov edi,n
        mov ebx,0
        mov ecx,0

        ;# Beginning of the Loop
        begin:
        mov eax,[esi]
        add eax,0h
        js negative

        positive:
        inc ebx
        jmp update

        negative:
        inc ecx

        update:
        add esi,4
        dec edi
        jnz begin
        ;# End of the Loop

        ;# Store Count in Variables
        mov [pcount],ebx
        mov [ncount],ecx

        ;# Print Positive Count
        print pmsg,plen
        mov eax,[pcount]
        call printEAXDigit

        print newLine,1

        ;# Print Negative Count
        print nmsg,nlen
        mov eax,[ncount]
        call printEAXDigit

        print newLine,1

        exit



;# Procedure for Printing Single Digit
printEAXDigit:
    add eax,30h
    mov [digit],eax
    mov eax,4
    mov ebx,1
    mov ecx,digit
    mov edx,1
    int 80h
    ret
