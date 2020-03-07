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
	dash: db 10,"-------------------------------------------",10;
	lenDash: equ $-dash;
	
	resMsg: db "! = ";
	lenResMsg: equ $-resMsg;
	
	errMsg: db "Invalid Command Line Argument Format!";
	lenErrMsg: equ $-errMsg;
	
	space: db " ";
	newLine: db 10;


section .bss
	inAscii: resb 16;
	outAscii: resb 16;
	number: resq 1;
	result: resq 1;


section .data
	global _start
	_start:
	
	pop rbx;
	cmp rbx,2h;
	jne argError
	
	pop rbx
	
	pop rbx;
	mov rsi,inAscii
	call getArgument;
	call _AsciiToHex;
	mov [number],rax;
	
	mov rbx,rax;
	push rbx;
	xor rax,rax;
	inc rax;
	
	call factorial
	
	mov [result],rax;
	
	print dash,lenDash;
	
	mov rax,[number];
	call _HexToAscii;
	print outAscii,16;
	
	print resMsg,lenResMsg;
	
	mov rax,[result];
	call _HexToAscii;
	print outAscii,16;
	
	print dash,lenDash;
	print newLine,1;
	
	
	exit:
	mov rax,60;
	mov rdi,00;
	syscall;
	
	argError:
		print newLine,1;
		print errMsg,lenErrMsg;
		print newLine,1;
		print newLine,1;
	jmp exit


getArgument:
;	DOC-STRING:
;	i) Stores the command line argument to the memory location pointed by RSI.
;	ii) Stores length of command line argument in RCX

	xor rcx,rcx;		
	xor rax,rax;
	begin3:
	mov al,byte[rbx];
	mov byte[rsi],al;
	inc rsi;
	inc rbx;
	inc rcx;
	cmp byte[rbx],0h;
 	jne begin3;
ret;		
		
		
factorial:
	pop rsi;	//pop IP
	pop rbx;	//No. in Stack
	push rsi;	//push back IP
	
	cmp rbx,1h;
	je endFactorial;
	cmp rbx,0h;
	je endFactorial;
	
	mul rbx;
	dec rbx;
	push rbx;
	call factorial;
	
endFactorial:
ret;		
		

_AsciiToHex:;		//ASCII in inAscii ----> HEX in RAX
	mov rsi,inAscii;
    xor rax,rax;
    begin1:
    cmp byte[rsi],0h;	//Compare With Null Character ie: 0h
    je end_AsciiToHex;
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

end_AsciiToHex:
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
    
end_HexToAscii:
ret	
