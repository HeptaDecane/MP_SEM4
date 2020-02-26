%include "macro.asm"

section .data
    dash: db 10,"----------------------------------------------------------",10;
    lenDash: equ $-dash;

	reqFile: db "Enter File Name (with Extension): ";
	lenReqFile: equ $-reqFile;
	
	errMsg: db "File Opening Error!";
	lenErrMsg: equ $-errMsg;
	
	newLine: db 10d;
	space: db " ";

section .bss
	buffer: resb 8192;
	lenBuffer: equ $-buffer;

	fileName: resb 64;
	fileDescriptor: resq 1;
	lenText: resq 1;

	count: resq 1;
	array: resb 20;
	temp: resb 1;
	
	inAscii: resb 16;
	outAscii: resb 4;
	
	
	
section .text
	global _start
	_start:
		print dash,lenDash;
		
		print reqFile,lenReqFile;
		read fileName,64;
		
		dec rax;
		mov byte[fileName+rax],0;
		
		fopen fileName;
		cmp rax,-1d;
		jle error;
		mov [fileDescriptor],rax;
		
		fread [fileDescriptor],buffer,lenBuffer;
		mov [lenText],rax;
		call _ProcessBuffer;
		call _BubbleSort;
		print array,count;
		jmp exit;
		
		
		
		error:
		print errMsg,lenErrMsg;
		
		exit:
		print dash,lenDash;
		fclose [fileDescriptor];
		mov rax,60;
		mov rdi,00;
		syscall;
		
		
_ProcessBuffer:	
	mov rcx,[lenText];
	mov rsi,buffer;
	mov rdi,array;
	
	begin0:
	mov al,[rsi];
	mov [rdi],al;
	
	update0:
	inc rsi;	//Number
	inc rsi;	//Line
	inc rdi;
	inc byte[count];
	dec rcx;
	dec rcx;
	jnz begin0;

	ret;	

_BubbleSort:
	xor rsi,rsi;
	xor rdi,rdi;
	
	
	xor rbx,rbx;	//i=0;
	
	outerLoop:
	xor rdx,rdx;		//j=0;
	mov rsi,array;		//array[j]
	
		innerLoop:
		mov rdi,rsi;
		inc rdi;		//array[j+1]
		
		mov al,[rsi];
		cmp al,[rdi];
		jbe skip
		
		swap:
		mov byte[temp],0h;
		mov cl,[rdi];
		mov [rdi],al;
		mov [rsi],cl;
		
		skip:
		inc rsi;
		
		inc rdx;
		cmp rdx,[count];
		jb innerLoop;
		
	inc rbx;
	cmp rbx,[count];
	jb outerLoop;
	
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
	
		

