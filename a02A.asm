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
	srcBlkBfr: db "Source Block Before Transfer: "
	lenSrcBlkBfr: equ $-srcBlkBfr
	
	desBlkBfr: db "Dest'n Block Before Transfer: "
	lenDesBlkBfr: equ $-desBlkBfr
	
	srcBlkAftr: db "Source Block After Transfer: "
	lenSrcBlkAftr: equ $-srcBlkAftr
	
	desBlkAftr: db "Dest'n Block After Transfer: "
	lenDesBlkAftr: equ $-desBlkAftr
	
	space: db " "
	newLine: db 10
	
	srcBlk: dq 1,2,3,4,5
	n1: equ 5
	
	desBlk: dq 0,0,0,0,0
	n2: equ 5
	
section .bss
	optionbuff resb 02
	dispbuff resb 02
	char_answer resb 16
	digitSpace resb 100
	digitSpacePos resb 8
    
    
section .text
	global _start:
	_start:
		print srcBlkBfr,lenSrcBlkBfr
		call _disSrcBlk
		print newLine,1
		
		print desBlkBfr,lenDesBlkBfr
		call _disDesBlk
		print newLine,1
		
		print newLine,1
		
		call _tranferLogic
		
		print srcBlkAftr,lenSrcBlkAftr
		call _disSrcBlk
		print newLine,1

		print desBlkAftr,lenDesBlkAftr
		call _disDesBlk
		print newLine,1
		
		mov rax,60
		mov rdi,00
		syscall
		
;_____________________________________________________________	
		
_disSrcBlk:
	mov rsi,srcBlk
	mov rcx,n1
	
	beginLoop2:
	mov rax,[rsi]
	push rsi
	push rcx
	call _printRAX
	print space,1
	pop rcx
	pop rsi
	
	update2:
	add rsi,8
	dec rcx
	jnz beginLoop1
	ret
	
	
_disDesBlk:
	mov rsi,desBlk
	mov rcx,n2
	
	beginLoop1:
	mov rax,[rsi]
	push rsi
	push rcx
	call _printRAX
	print space,1
	pop rcx
	pop rsi
	
	update1:
	add rsi,8
	dec rcx
	jnz beginLoop1
	ret	


_tranferLogic:
	mov rsi,srcBlk
	mov rdi,desBlk
	mov rcx,n1
	
	beginLoop3:
	mov rax,[rsi]
	mov [rdi],rax
	
	update3:
	add rsi,8
	add rdi,8
	dec rcx
	jnz beginLoop3
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
	
	
	
	
	
	
	
