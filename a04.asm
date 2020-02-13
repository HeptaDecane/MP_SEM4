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
	
	option1: db "          Menu",10,"Press 1: Repeated Addition";
	lenOption1: equ $-option1;

	option2: db "Press 2: Shift Addition";
	lenOption2: equ $-option2;

	req: db "Enter Choice: ";
	lenReq: equ $-req;

	reqHex1: db "Enter 1st Hex Number: ";
	lenReqHex1: equ $-reqHex1;

	reqHex2: db "Enter 2nd Hex Number: ";
	lenReqHex2: equ $-reqHex2;

	result: db "Product = ";
	lenResult: equ $-result;

	space: db " ";
	newLine: db 10d;

section .bss
	choice: resb 1;
	inAscii: resb 16;
	outAscii: resb 16;

section .text
	global _start
	_start:
		menu:
		print newLine,1;
		print dash,lenDash;
		print option1,lenOption1;
		print newLine,1;
		print option2,lenOption2;
		print newLine,1;
		print req,lenReq;
		read choice,2;

		cmp byte[choice],31h;
		je label1;

		cmp byte[choice],32h;
		je label2;

		exit:
		mov rax,60d;
		mov rdi,00d
		syscall;

		label1:

		print newLine,1
		print reqHex1,lenReqHex1;
		read inAscii,16;
		call _AsciiToHex;
		push rax;

		print reqHex2,lenReqHex2;
		read inAscii,16;
		call _AsciiToHex;
		push rax;

		xor rax,rax;

		pop rbx;
		pop rcx;

		repeatedAddition:
		add rax,rbx;
		dec rcx;
		jnz repeatedAddition

		call _HexToAscii;
		print result,lenResult;
		print outAscii,16;
		print newLine,1

		jmp menu;


		label2:
		
		print newLine,1
		print reqHex1,lenReqHex1;
		read inAscii,16;
		call _AsciiToHex;
		push rax;

		print reqHex2,lenReqHex2;
		read inAscii,16;
		call _AsciiToHex;
		push rax;
		
		pop rbx;
		pop rdx;
		xor rax,rax;
		xor rcx,rcx;
		
		shiftAdd:
		shr rbx,1;
		jnc skip
		add rax,rdx
		skip:
		shl rdx,1;
		add rbx,0h
		jnz shiftAdd
		
		call _HexToAscii;
		
		
		print result,lenResult;
		print outAscii,16
		print newLine,1



		jmp menu;




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
    mov rsi,outAscii+15d;
    mov rcx,16d

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
