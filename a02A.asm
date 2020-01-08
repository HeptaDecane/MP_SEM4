;# NON-OVERLAPPING BLOCK TRANSFER

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
	title: db "NON-OVERLAPPED BLOCK TRANSFER"
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

	srcBlkBfr: db "Source Block Before Transfer: "
	lenSrcBlkBfr: equ $-srcBlkBfr

	desBlkBfr: db "Dest^n Block Before Transfer: "
	lenDesBlkBfr: equ $-desBlkBfr

	srcBlkAftr: db "Source Block After Transfer: "
	lenSrcBlkAftr: equ $-srcBlkAftr

	desBlkAftr: db "Dest^n Block After Transfer: "
	lenDesBlkAftr: equ $-desBlkAftr

	srcBlk: db 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
	n1: equ 16
	
	space: db " "
	newLine: db 10
	tab: db " :    "

	desBlk: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	n2: equ 16
;_______________________________________________________________________________

section .bss
	choice: resb 01
	digitSpace: resb 100
	digitSpacePos: resb 8
;_______________________________________________________________________________

section .text
	global _start
	_start:
		print srcBlkBfr,lenSrcBlkBfr
		print newLine,1
		call _disSrcBlk
		print newLine,1

		print desBlkBfr,lenDesBlkBfr
		print newLine,1
		call _disDesBlk
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


		label1:	;* Without String Instructions
		print message1,lenMessage1
		print newLine,1
		call _tranferLogic

		print srcBlkAftr,lenSrcBlkAftr
		print newLine,1
		call _disSrcBlk
		print newLine,1

		print desBlkAftr,lenDesBlkAftr
		print newLine,1
		call _disDesBlk
		print newLine,1

		jmp menu


		label2:		;* With String Instructions
		print message2,lenMessage2
		print newLine,1

		mov rsi,srcBlk
		mov rdi,desBlk
		mov rcx,16

		cld
		rep movsb

		print srcBlkAftr,lenSrcBlkAftr
		print newLine,1
		call _disSrcBlk
		print newLine,1

		print desBlkAftr,lenDesBlkAftr
		print newLine,1
		call _disDesBlk
		print newLine,1

		jmp menu
;_______________________________________________________________________________

_disSrcBlk:
	mov rsi,srcBlk
	mov rcx,n1

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

_disDesBlk:
	mov rsi,desBlk
	mov rcx,n2

	beginLoop2:
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

	update2:
	inc rsi
	dec rcx
	jnz beginLoop1
	ret
;_______________________________________________________________________________

_tranferLogic:
	mov rsi,srcBlk
	mov rdi,desBlk
	mov rcx,n1

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
