;# Prints the Contents of RAX register in HEX format

%macro print 2
    mov rax,01d;
    mov rdi,01d;
    mov rsi,%1;
    mov rdx,%2;
    syscall;
%endmacro

%macro read 2
    mov rax,00d;
    mov rdi,00d;
    mov rsi,%1;
    mov rdx,%2;
    syscall;
%endmacro
;_______________________________________________________________________________

section .data

    message: db "HEX Number: ";
    lenMessage: equ $-message;
    newLine: db 10d;
;_______________________________________________________________________________

section .bss
    ascii: resb 100d;
;_______________________________________________________________________________

section .text
    global _start
    _start:
        mov rax,51A2DFh;      //Content to be Printed in RAX

        mov rsi,ascii+15d;
        mov rcx,16d

        begin:
        xor rdx,rdx;        //remainder in rdx
        mov rbx,10h;
        div rbx;

        cmp dl,09h;
        jbe add30;
        add dl,07h;
        add30:
        add dl,30h;
        mov byte[rsi],dl;

        update:
        dec rsi;
        dec rcx;
        jnz begin;

        print message,lenMessage;
        print ascii,16d;
        print newLine,01d;

        mov rax,60d;
        mov rdi,00d;
        syscall;
