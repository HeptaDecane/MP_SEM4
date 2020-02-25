global _TextCount,_AsciiToHex,_HexToAscii;
extern fileDescriptor,char,buffer,lenText;

%include "macro.asm"

section .data
	spaceMsg: db "No. of Spaces: ";
	lenSpaceMsg: equ $-spaceMsg;

	lineMsg: db "No. of Lines: ";
	lenLineMsg: equ $-lineMsg;

	charMsg: db "No. of Character Occurances: "
	lenCharMsg: equ $-charMsg;

	space: db " ";
    newLine: db 10d;

section .bss
	spaceCount: resq 1;
	lineCount: resq 1;
	charCount: resq 1;

	inAscii: resb 16;
	outAscii: resb 4;

section .text
;Procedures Only

_TextCount:
	xor rbx,rbx;
	mov bl,[char];

	mov rsi,buffer;
	mov rcx,[lenText];

	begin0:

		case_space:
		cmp byte[rsi],32d;
		jne case_line;
		inc qword[spaceCount];
		jmp update0;

		case_line:
		cmp byte[rsi],10d;
		jne case_character;
		inc qword[lineCount];
		jmp update0;

		case_character:
		cmp byte[rsi],bl;
		jne update0;
		inc qword[charCount];

	update0:
	inc rsi;
	dec rcx;
	jnz begin0;

	print newLine,1;
	print spaceMsg,lenSpaceMsg;
	mov rax,[spaceCount];
	call _HexToAscii;
	print outAscii,4;

	print newLine,1;
	print lineMsg,lenLineMsg;
	mov rax,[lineCount];
	call _HexToAscii;
	print outAscii,4;

	print newLine,1;
	print charMsg,lenCharMsg;
	mov rax,[charCount];
	call _HexToAscii;
	print outAscii,4

	ret

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
