%include"macro.asm"

section .data
    dash: db 10,"----------------------------------------------------------",10;
    lenDash: equ $-dash;
    
    txtMsg: db "Contents of File: ";
    lenTxtMsg: equ $-txtMsg;
    
    cpMsg: db "File Copied";
    lenCpMsg: equ $-cpMsg;
    
    delMsg: db "File Deleted!";
    lenDelMsg: equ $-delMsg;
    
    cmdErrMsg: db "Error: Invalid Command Format!";
    lenCmdErrMsg: equ $-cmdErrMsg;
    
    fileErrMsg: db "File Handling Error!";
    lenFileErrMsg: equ $-fileErrMsg;
    
    newLine: db 10d;
	space: db " ";
	
	
section .bss
	buffer: resb 8192;
	lenBuffer: equ $-buffer;
	
	fileName: resb 32;
	
	fileName1: resb 32;
	lenFileName1: resb 1;
	
	fileName2: resb 32;
	lenFileName2: resb 1;
	
	command: resb 10;
	lenCommand resb 1;
	
	count: resb 1;
	outAscii:resb 4;
	
	
section .text
	global _start
	_start:
	print dash,lenDash;
	
	pop rbx;
	mov byte[count],bl;
	
	pop rbx;
	
	pop rbx;
	mov rsi,command;
	call getArgument;
	mov byte[lenCommand],cl;
 	
 	call resolveCommand;
	cmp rax,0x3B
	je copy;
	cmp rax,0x42
 	je type;
 	cmp rax,0xB3
 	je delete; 
	
	commandError:
	print newLine,1;
	print cmdErrMsg,lenCmdErrMsg;
	print newLine,1;
	jmp exit
	
	fileError:
	print newLine,1;
	print fileErrMsg,lenFileErrMsg;
	print newLine,1;
	jmp exit	
	
	
	exit:
	mov rax,60;
	mov rdi,00;
	syscall;
	
	
	
	
	copy:
		cmp byte[count],4h
		jne commandError;
		
		print newLine,1;
		print cpMsg,lenCpMsg;
		print newLine,1;	
	jmp exit;
	
	
	
	
	type:
		cmp byte[count],3h
		jne commandError;	

		print newLine,1;
		print txtMsg,lenTxtMsg;
		print newLine,1;
	jmp exit




	delete:
		cmp byte[count],3h
		jne commandError;

		print newLine,1;
		print delMsg,lenDelMsg;
		print newLine,1;
	jmp exit;
		
		
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
	cmp byte[rbx],0H;
 	jne begin3;
ret;



resolveCommand:
;	DOC-STRING:
;	i) Distinguishes Command {COPY,TYPE,DELETE}
;	ii) returns last two digits of ASCII sum in RAX;
;	eg:-
;		COPY   :3Bh
;		DELETE :B3h
;		TYPE   :42h	

	mov rsi,command;
	xor rax,rax;
	begin4:
	cmp byte[rsi],0h;
	je done4
	add al,byte[rsi];
	add rax,0h;
	inc rsi;
	jmp begin4;
	done4:
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






