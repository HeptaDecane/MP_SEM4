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
	mov rdi,%2;
	syscall;
%endmacro

section .data
	option1: db "Press 1: Repeated Addition";
	lenOption1: equ $-option1;
	
	option2: db "Press 2: Arithmetic Shift Addition";
	lenOption2: equ $-option2;
	
	option3: db "Press 3: Exit";
	lenOption3: equ $-option3;
	
	request: db "Enter Choice: ";
	lenRequest: equ $-request;
	
	reqHex: db "Enter HEX Number: ";
	lenReqHex: equ $-reqHex;
	
	space: db " ";
	newLine: db 10;


section .bss
	choice: resb 1;
	inAscii: resb 16;
	outAscii: resb 16;
	
section .text
	global _start
	_start:
		menu:
		print option1,lenOption1;
		print newLine,1;
		print option2,lenOption2;
		print newLine,1;
		print request,lenRequest;
		read choice,2;
		
		
		
		
		
		exit:
		mov rax,60;
		mov rdi,00;
		syscall;
	
	
	
	
	
	
	
