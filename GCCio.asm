;GCC scanf and printf function for input and output of double (8bytes)

extern printf,scanf

%macro _printf 1
	pop qword[stack];		
	mov rdi,formatpf;
	movsd xmm0,qword[%1];
	mov rax,1;
	call printf;
	push qword[stack];
%endmacro

%macro _scanf 1
	pop qword[stack];
	mov rdi,formatsf;
	mov rsi,rsp;
	call scanf
	mov rax,qword[rsp];
	mov qword[%1],rax;
	push qword[stack];
%endmacro
	


section .data
	formatpf: db "%lf",10,0;
	formatsf: db "%lf",0;
	x: dq 5.0


section .bss
	stack: resq 1;
	var: resq 1;
	
	
section .text
	global main
	main:
		_scanf var;
		_printf var;
		
		exit:
		mov rax,60;
		mov rdi,0;
		syscall;
		









