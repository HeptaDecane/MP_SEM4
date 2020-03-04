%include"macro.asm"

section .data
    dash: db 10,"----------------------------------------------------------",10;
    lenDash: equ $-dash;
    
    contentMsg: db "Contents of File: ";
    lenContentMsg: equ $-contentMsg;
    
    copyMsg: db "File Copied";
    lenCopyMsg: equ $-copyMsg;
    
    deleteMsg: db "File Deleted!";
    lenDeleteMsg: equ $-deleteMsg;
    
    errMsg: db "Command Not Found!";
    lenErrMsg: equ $-errMsg;
    
    newLine: db 10d;
	space: db " ";
	
section .bss
	buffer: resb 8192;
	lenBuffer: equ $-buffer;
	
	fileName: resb 32;
	fileName1: resb 32;
	fileName2: resb 32;
	command: resb 10;
	lenCommand resb 1;
	inAscii: resb 16;
	outAscii:resb 4;
	
section .text
	global _start
	_start:
	pop rbx;
	pop rbx;
	
	call getCommand;
 	print command,[lenCommand];
 	
	
	exit:
	mov rax,60;
	mov rdi,00;
	syscall;
	
	
getCommand:
	pop rbx;
	xor rcx,rcx;
	mov rsi,command;
	
	begin3:
	mov al,byte[rbx];
	mov byte[rsi],al;
	inc rsi;
	inc rbx;
	inc rcx;
	cmp byte[rbx],0H;
 	jne begin3;
 	mov byte[lenCommand],cl;
ret;






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




