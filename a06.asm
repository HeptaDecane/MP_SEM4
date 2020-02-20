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
	
	rmMsg: db "Processor is in Real Mode";
	lenRmMsg: equ $-rmMsg;
	
	peMsg: db "Processor is in Protected Mode";
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
	newLine: db 10d;
	
section .bss
	gdt: resq 1
	choice: resb 1;
	inAscii: resb 16;
	outAscii: resb 16;	

section .text
	global _start
	_start:
		sgdt [gdt];
		mov rax,[gdt]
		call _HexToAscii;
		print outAscii,16;
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

