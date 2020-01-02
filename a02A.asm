%macro print 2
    mov rax,01
    mov rdi,01
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro

%macro read 2
    mov rax,00
    mov rdi,00
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro

section .data
    menumsg: db 10,'##Menu for Non-overlapped Block Transfer##',10
             db 10,'1.Block Transfer without using string instructions'
             db 10,'2.Block Transfer with using string instructions'
             db 10,'3.Exit',10
    menumsg_len: equ $-menumsg

    blk_bfrmsg: db "Block contents before transfer"
    blk_bfrmsg_len: equ $-blk_bfrmsg

    blk_afrmsg: db 10,'Block contents after transfer'
    blk_afrmsg_len: equ $-blk_afrmsg

    srcmsg: db 10,'Source block contents: '
    srcmsg_len: equ $-srcmsg

    dstmsg: db 10,'Destination block contents: '
    dstmsg_len: equ $-dstmsg

    srcblk: dq 10h,02h,03h,04h,05h
    dstblk: db 00,00,00,00,00

    spacechar: db " "
    spchlength: equ $-spacechar


section .bss
    optionbuff resb 02
    dispbuff resb 02
    char_answer resb 16
    digitSpace resb 100
    digitSpacePos resb 8


section .text
    global _start
    _start:
        print blk_bfrmsg,blk_bfrmsg_len
        call dispsrc_blk_proc
        ;call disdest_blk_proc

        exit:
        mov rax,60
        mov rdi,0
        syscall

dispsrc_blk_proc:
        print srcmsg,srcmsg_len
        mov rsi,srcblk
        mov rcx,5

        beginLoop1:
        mov rax,[rsi]
        push rsi
        push rcx
        call _printRAX
        print spacechar,spchlength

        update1:
        pop rcx
        pop rsi
        add rsi,8
		dec rcx
        jnz beginLoop1
        ret

_printRAX:
    mov rcx, digitSpace
    mov rbx, 0
    mov [rcx], rbx
    inc rcx
    mov [digitSpacePos], rcx

_printRAXLoop:
    mov rdx, 0
    mov rbx, 10
    div rbx
    push rax
    add rdx, 48

    mov rcx, [digitSpacePos]
    mov [rcx], dl
    inc rcx
    mov [digitSpacePos], rcx

    pop rax
    cmp rax, 0
    jne _printRAXLoop

_printRAXLoop2:
    mov rcx, [digitSpacePos]

    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall

    mov rcx, [digitSpacePos]
    dec rcx
    mov [digitSpacePos], rcx

    cmp rcx, digitSpace
    jge _printRAXLoop2

    ret
