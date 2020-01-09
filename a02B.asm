;# OVERLAPPING BLOCK TRANSFER

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
;_______________________________________________________________________________

section .data
	title: db "OVERLAPPED BLOCK TRANSFER"
	lenTitle: equ $-title

	option1: db "Press 1: Block Transfer Without String Instructions"
	lenOption1: equ $-option1

	option2: db "Press 2: Block Transfer With String Instructions"
	lenOption2: equ $-option2

	option3: db "Press 0: Exit"
	lenOption3: equ $-option3

	request: db "Enter Choice: "
	lenRequest: equ $-request

	message1: db "Block Transfer WITHOUT String Instructions"
	lenMessage1: equ $-message1

	message2: db "Block Transfer WITH String Instructions"
	lenMessage2: equ $-message2

	blkBfr: db "Block Before Transfer: "
	lenBlkBfr: equ $-blkBfr

	blkAftr: db "Block After Transfer: "
	lenBlkAftr: equ $-blkAftr

	space: db " "
	newLine: db 10
	tab: db " :    "

	block: db 1,2,3,4,5,6,7,8,0,0,0,0,0,0,0,0
	n: equ 16
;_______________________________________________________________________________

section .bss
	choice: resb 01
	digitSpace: resb 100
	digitSpacePos: resb 8
	inputBuff: resb 2
	pos: resb 2
;_______________________________________________________________________________

section .text
	global _start
	_start:

	print newLine,1
	print blkBfr,lenBlkBfr
	print newLine,1
	call _displayBlock
	print newLine,1

	menu:
	print newLine,1
	print title,lenTitle
	print newLine,1
	print option1,lenOption1
	print newLine,1
	print option2,lenOption2
	print newLine,1
	print option3,lenOption3
	print newLine,1

	print request,lenRequest
	read choice,2		;* 2 bytes for read statement to execute each time
	print newLine,1

	cmp byte[choice],31h
	je label1

	cmp byte[choice],32h
	je label2

	exit:
	mov rax,60
	mov rdi,00
	syscall

	label1:		;* Without String Instructions
	print message1,lenMessage1
	print newLine,1

	call _tranferLogic

	print blkAftr,lenBlkAftr
	print newLine,1
	call _displayBlock
	print newLine,1

	jmp menu


	label2:		;* With String Instructions
	print message2,lenMessage2
	print newLine,1

	mov rsi,block
	mov rdi,block
	add rdi,8
	mov rcx,8

	cld
	rep movsb

	print blkAftr,lenBlkAftr
	print newLine,1
	call _displayBlock
	print newLine,1

	jmp menu
;_______________________________________________________________________________

_tranferLogic:
	mov rsi,block
	mov rdi,block
	add rdi,8
	mov rcx,8

	beginLoop3:
	mov al,byte[rsi]
	mov byte[rdi],al

	update3:
	inc rsi
	inc rdi
	dec rcx
	jnz beginLoop3
	ret
;_______________________________________________________________________________

_displayBlock:
	mov rsi,block
	mov rcx,n

	beginLoop1:
	mov al,byte[rsi]

	push rsi
	push rcx
	call _printRAX
	print tab,6

	pop rcx
	pop rsi
	mov rax,rsi
	push rsi
	push rcx
	call _printRAX
	print newLine,1

	pop rcx
	pop rsi

	update1:
	inc rsi
	dec rcx
	jnz beginLoop1
	ret
;_______________________________________________________________________________

_printRAX:		;Hex to ASCII
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
;_______________________________________________________________________________
