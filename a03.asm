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
	option1: db "Press 1: HEX to BCD";
	lenOption1: equ $-option1;
	
	option2: db "Press 2: BCD to HEX";
	lenOption2: equ $-option2;
	
	option3: db "Press 3: Exit";
	lenOption3: equ $-option3;
	
	request: db "Enter Choice: ";
	lenRequest: equ $-request;
	
	req1: db "Enter HEX: ";
	lenReq1: equ $-req1;
	
	req2: db "Enter BCD: ";
	lenReq2: equ $-req2;
	
	msg1: db "BCD Equivalent: ";
	lenMsg1: equ $-msg1;
	
	msg2: db "BCD Equivalent: ";
	lenMsg2: equ $-msg2;	
	
	space: db " ";
	newLine: db 10;

section .bss
	hex: resb 100;
	inAscii: resb 100;
	outAscii: resb 100;
	choice: resb 1;
	
section .text
	global _start
	_start:
		menu:
		print option1,lenOption1;
		print newLine,1;
		print option2,lenOption2;
		print newLine,1;	
		print option3,lenOption3;
		print newLine,1;
		
		print request,lenRequest;
		read choice,2;
		
		cmp byte[choice],31h;
		je label1;
		
		cmp byte[choice],32h;
		je label2;
		
		exit:
		mov rax,60;
		mov rsi,00;
		syscall;	
		
		label1:
		print newLine,1;
		print req1,lenReq1;
		read inAscii,10
		call _AsciiToHex;
		call _HexToAscii;
		print msg1,lenMsg1;
		print outAscii,16;
		print newLine,1;
		jmp menu;
		
		label2:
		print newLine,1;
		print option2,lenOption2;
		print newLine,1;
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

    begin:
    xor rdx,rdx;
    mov rbx,0x10;
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
    jnz begin;

    ret	
	
	
	
