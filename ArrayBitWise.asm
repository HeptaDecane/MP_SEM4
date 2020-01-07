%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro

section .data
    msg: db "Array Elments: "
    len: equ $-msg
    space: db " "
    newLine: db 10
    arr: db 9,7,3,9,2,4
    n: equ 6

section .bss
    digit: resb 1
    digitSpace resb 100
    digitSpacePos resb 8

section .text
    global _start
    _start:
        print msg,len
        mov rsi,arr                     ;# esi holding the base Address of Array
        mov rcx,n                       ;# edi holding count af Array Elments


        ;# Beginning of the Loop
        begin:
        ;mov rax,0
        mov al,byte[rsi]
        push rsi
        push rcx
        call _printRAX
        print space,1
        pop rcx
        pop rsi
        update:

        add rsi,1                       ;# inc esi by 4bytes to point to next array element (arr is of type doubleword-dd)
        dec rcx                         ;# decrement count;
        jnz begin                       ;# id count!=0 goto 'begin'
        ;# End of the Loop

        print newLine,1

        mov rax,60
        mov rdi,00
        syscall

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


;   Note:
;      Use esi and edi registers to traverse array,
;        because eax and ebx registers are updated during system calls.
