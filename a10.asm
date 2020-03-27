global main
extern printf,scanf;


%macro _printf 3
	pop qword[stack];
	mov rdi,%1;
	movsd xmm0,qword[%2];		//MOVSD — Move Scalar Double-Precision Floating-Point Value
	movsd xmm1,qword[%3];
	mov rax,2;
	call printf
	push qword[stack];
%endmacro

%macro _scanf 1
	pop qword[stack];
	mov rdi,readFormat;
	mov rsi,rsp;
	call scanf;
	mov rax,qword[rsp];
	mov qword[%1],rax;
	push qword[stack];
%endmacro

%macro print 2
	mov rax,1;
	mov rdi,1;
	mov rsi,%1;
	mov rdx,%2;
	syscall
%endmacro



section .data
	eqn: db "Ax^2 + Bx + C = 0",10;
	lenEqn: equ $-eqn;
	
	reqA: db "Coefficient of x^2 (A): ";
	lenReqA: equ $-reqA;
	
	reqB: db "Coefficient of x (B): ";
	lenReqB: equ $-reqB;
	
	reqC: db "Constant (C): ";
	lenReqC: equ $-reqC;
	
	rootsMsg: db "Roots:",10;
	lenRootsMsg: equ $-rootsMsg;
	
	root1Format: db "%lf + %lf i",10,0;
	root2Format: db "%lf - %lf i",10,0;
	readFormat: db "%lf",0;
	
	space: db " ";
	newLine: db 10d;
	
	zero: dq 0.0;
	two:  dq 2.0;
	four: dq 4.0;
	
	

section .bss
	stack: resq 1;
	a: resq 1;
	b: resq 1;
	c: resq 1;
	bSquare: resq 1;		//b^2
	fourAC: resq 1;			//4ac
	twoA: resq 1;			//2a
	d: resq 1;				//d=b^2-4ac (determinant)
	rootD: resq 1;			//d^(1/2)
	root1: resq 1;			//First Root
	root2: resq 1;			//Second Root
	real: resq 1;			//real Part of the root
	img: resq 1;			//imaginary part of the root
	
	
	
section .text
	main:
		finit;
		
		print eqn,lenEqn;
		print newLine,1;
		
		print reqA,lenReqA;
		_scanf a;
		
		print reqB,lenReqB;
		_scanf b;
		
		print reqC,lenReqC;
		_scanf c;
		
		fld qword[b];
		fmul qword[b];
		fstp qword[bSquare];	
		
		fld qword[two];
		fmul qword[a];
		fstp qword[twoA];
		
		fld qword[four];
		fmul qword[a];
		fmul qword[c];
		fstp qword[fourAC];
		
		fld qword[bSquare];
		fsub qword[fourAC];
		fstp qword[d];
		
								;btr - bit test and reset
		btr qword[d],63;	//check and reset signBit of d (determinant), if negative carry flag is set
		jc negativeD
		
		positiveD:
		fld qword[d];
		fsqrt;
		fstp qword[rootD];
		
		fldz;				//loads 0.0 onto the stack
		fsub qword[b];
		fadd qword[rootD];
		fdiv qword[twoA];
		fstp qword[root1];
		
		fldz; 
		fsub qword[b];
		fsub qword[rootD];
		fdiv qword[twoA];
		fstp qword[root2];
		
		print newLine,1;
		print rootsMsg,lenRootsMsg;
		_printf root1Format,root1,zero;
		_printf root1Format,root2,zero;
		
		jmp exit;
		
		
		negativeD:
		fld qword[d];
		fsqrt;
		fstp qword[rootD];
		
		fldz
		fsub qword[b];
		fdiv qword[twoA];
		fstp qword[real];
		
		fld qword[rootD];
		fdiv qword[twoA];
		fstp qword[img];
		
		print newLine,1;
		print rootsMsg,lenRootsMsg;
		_printf root1Format,real,img;
		_printf root2Format,real,img;
		
		
	exit:
		mov rax,60;
		mov rdi,00;
		syscall;
