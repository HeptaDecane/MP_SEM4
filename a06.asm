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

section .data
	dash: db "-------------------------------------------",10;
	lenDash: equ $-dash;

	rmMsg: db "Processor is in Real Mode!";
	lenRmMsg: equ $-rmMsg;

	peMsg: db "Processor is in Protected Mode!";
	lenPeMsg: equ $-peMsg;

	mswMsg: db "Contents of MSW: ";
	lenMswMsg: equ $-mswMsg;

	gdtrMsg: db "Contents of GDTR: ";
	lenGdtrMsg: equ $-gdtrMsg;

	idtrMsg: db "Contents of IDTR: ";
	lenIdtrMsg: equ $-idtrMsg;

	ldtrMsg: db "Contents of LDTR: ";
	lenLdtrMsg: equ $-ldtrMsg;

	trMsg: db "Contents of TR: ";
	lenTrMsg: equ $-trMsg;

	space: db " ";
	colon: db ":";
	newLine: db 10d;

section .bss
	gdt:resd 1
	 	resw 1;		//48 bits

	idt:resd 1
	 	resw 1;		//48 bits

	ldt: resw 1;	//16 bits

	tr: resw 1;		//16 bits

	msw: resw 1;

	inAscii: resb 16;
	outAscii: resb 4;

section .text
	global _start
	_start:
		smsw ax;
		bt ax,0;
		jc protected_mode

		real_mode:
		print newLine,1;
		print rmMsg,lenRmMsg;
		print newLine,1;

		protected_mode:
		print newLine,1;
		print peMsg,lenPeMsg;
		print newLine,1;

		store_descriptor_contents:
		smsw word[msw];
		sgdt [gdt];
		sidt [idt];
		sldt [ldt];
		str [tr];

		display_GDTR_contents:
		print newLine,1;
		print gdtrMsg,lenGdtrMsg;
		print newLine,1;
		mov ax,word[gdt+4]
		call _HexToAscii;
		print outAscii,4;
		mov ax,word[gdt+2];
		call _HexToAscii;
		print outAscii,4;
		print colon,1;
		mov ax,word[gdt];
		call _HexToAscii;
		print outAscii,4;
		print newLine,1;

		display_IDTR_contents:
		print newLine,1;
		print idtrMsg,lenIdtrMsg;
		print newLine,1;
		mov ax,word[idt+4]
		call _HexToAscii;
		print outAscii,4;
		mov ax,word[idt+2];
		call _HexToAscii;
		print outAscii,4;
		print colon,1;
		mov ax,word[idt];
		call _HexToAscii;
		print outAscii,4;
		print newLine,1;

		display_LDTR_contents:
		print newLine,1;
		print ldtrMsg,lenLdtrMsg;
		print newLine,1;
		mov ax,word[ldt];
		call _HexToAscii;
		print outAscii,4;
		print newLine,1;

		display_TR_contents:
		print newLine,1;
		print trMsg,lenTrMsg;
		print newLine,1;
		mov ax,word[tr];
		call _HexToAscii;
		print outAscii,4;
		print newLine,1;

		diaplay_MSW_contents:
		print newLine,1;
		print mswMsg,lenMswMsg;
		print newLine,1;
		mov ax,word[msw];
		call _HexToAscii;
		print outAscii,4;
		print newLine,1;

		exit:
		mov rax,60;
		mov rdi,0
		syscall;




_AsciiToHex:;		//ASCII in inAscii ----> HEX in RAX
	mov rsi,inAscii;
    xor rax,rax;
    begin1:
    cmp byte[rsi],0xA;	//Compare With New Line
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
    ret


_HexToAscii:;		// HEX in RAX -----> ASCII in outAscii
    mov rsi,outAscii+3d;
    mov rcx,4d

    begin2:
    xor rdx,rdx;
    mov rbx,10h;	//16d
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
    jnz begin2;

    ret
