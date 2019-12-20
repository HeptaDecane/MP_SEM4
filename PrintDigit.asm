section .data
    digit: db 0

section .bss

section .text
    global _start
    _start:
        mov eax,8h
        call _printEAXDigit
        mov eax,1
        mov ebx,0
        int 80h


_printEAXDigit:
    add eax, 30h
    mov [digit],eax
    mov ecx,digit              ;ecx stores const char* while printing String
    mov eax,4                  ;here digit is memory location and [digit] is value
    mov ebx,1
    mov edx,1
    int 80h
    ret
