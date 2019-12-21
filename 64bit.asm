%macro print 2
    mov rax,1
    mov rdi,1
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro

%macro exit 0
    mov rax,60
    mov rdi,0
    syscall
%endmacro

section .data
pmsg: db "The Count of Positive Numbers: "
plen: equ $-pmsg
nmsg: db "The Count of Negative Numbers: "
nlen: equ $-nmsg
newLine: db 10
arr: dq 600,-500,432,-35,2,1
n: equ 6

section .bss
    pcount: resq 1
        ncount: resq 1
        digit: resq 1

section .text
        global _start
        _start:
            mov rsi,arr
            mov rdi,n
            mov r8,0
            mov r9,0

            begin:
            mov rax,[rsi]
            add rax,0h
            js negative

            positive:
            inc r8
            jmp update

            negative:
            inc r9

            update:
            add rsi,8
            dec rdi
            jnz begin

            mov [pcount],r8
            mov [ncount],r9

            print pmsg,plen
            mov rax,[pcount]
            call printRAXDigit

            print newLine,1

            print nmsg,nlen
            mov rax,[ncount]
            call printRAXDigit

            print newLine,1

            exit


printRAXDigit:
    add rax,30h
    mov [digit],rax
    mov rax,1
    mov rdi,1
    mov rsi,digit
    mov rdx,1
    syscall
    ret
