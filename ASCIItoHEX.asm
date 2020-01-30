;#

%macro print 2
    mov rax,01;
    mov rdi,01;
    mov rsi,%1;
    mov rdx,%2;
    syscall;
%endmacro

%macro read 2
    mov rax,00;
    mov rdi,00;
    mov rsi,%1;
    mov rdx,%2;
    syscall;
%endmacro
;_______________________________________________________________________________

section .data

    message1: db "Enter HEX Number: ";
    lenMessage1: equ $-message1;

    message2: db "HEX Number: ";
    lenMessage2: equ $-message2;

    newLine: db 10d;
;_______________________________________________________________________________

section .bss
    ascii: resb 100;
    hex: resb 10;
;_______________________________________________________________________________

section .text
    global _start
    _start:
        read hex,16;
        mov rsi,hex;
        xor rax,rax;

        begin1:
        cmp byte[rsi],10d;
        je done;
        rol rax,04d;
        mov bl,byte[rsi];
        cmp bl,39h;
        jbe sub30
        sub bl,07h;
        sub30:
        sub bl,30h;
        add al,bl;
        inc rsi;
        jmp begin1;


        done:
        call _printRAXhex;



        mov rax,60d;
        mov rdi,00d;
        syscall;


_printRAXhex:
    mov rsi,ascii+15d;
    mov rcx,16d

    begin:
    xor rdx,rdx;
    mov rbx,0x10;
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

    print ascii,16d;

    ret
