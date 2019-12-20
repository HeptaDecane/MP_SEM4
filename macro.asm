%macro print 2
    mov eax,4
    mov ebx,1
    mov ecx,%1
    mov edx,%2
    int 80h
%endmacro

%macro exit 0
    mov eax,1
    mov ebx,0
    int 80h
%endmacro

section .data
    msg1: db "H1"
    msg2: db "hello world"
    newLine: db 10

section .text
    global _start
    _start:
        print msg1,2
        print newLine,1
        print msg2,11
        print newLine,1
        exit
