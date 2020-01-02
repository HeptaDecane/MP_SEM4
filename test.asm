%macro scall 4
        mov rax,%1
        mov rdi,%2
        mov rsi,%3
        mov rdx,%4
        syscall
%endmacro

section .data
        arr dq 7222222211111111h,-1111111100000000h,-7999999999999999h,7FFFFFFFFFFFFFFFh
        n equ 4
        pmsg db 10d,13d,"The Count of Positive No: ",10d,13d
        plen equ $-pmsg
        nmsg db 10d,13d,"The Count of Negative No: ",10d,13d
        nlen equ $-nmsg
        nwline db 10d,13d

section .bss
        pcnt resq 1
        ncnt resq 1
        char_answer resb 16

section .text
        global _start
        _start:
        mov rax,12
        call display
                mov rax,60
                mov rbx,0
                syscall


;display procedure for 64bit
disp8_proc:
    mov rsi,dispbuff
    mov rcx,02

dup1:
    rol bl,4
    mov dl,bl
    and dl,0Fh
    cmp dl,09H
    jbe dskip
    add dl,07h

dskip:add dl,30h
      mov [rsi],dl
      inc rsi
      loop dup1

      scall 1,1,dispbuff,02

      ret
