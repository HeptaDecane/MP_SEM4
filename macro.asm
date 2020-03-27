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

%macro fopen 2
    mov rax,02;     //SYS_OPEN
    mov rdi,%1;     //file-name
    mov rsi,%2;     //File-Open Mode
    mov rdx,0777o;  //File-Permission
    syscall;
%endmacro

%macro fclose 1
    mov rax,03;     //SYS_CLOSE
    mov rdi,%1;     //File-Descriptor
    syscall;
%endmacro

%macro fread 3
    mov rax,00;     //SYS_READ
    mov rdi,%1;     //File-Descriptor
    mov rsi,%2;     //Buffer
    mov rdx,%3;     //Count
    syscall;
%endmacro

%macro fwrite 3
    mov rax,01;     //SYS_WRITE
    mov rdi,%1;     //File-Descriptor
    mov rsi,%2;     //Buffer
    mov rdx,%3;     //Count
    syscall;
%endmacro


section .data
	inAscii  db "0000000000000000";
	outAscii db "0000000000000000";

_AsciiToHex:;		//ASCII in inAscii ----> HEX in RAX
	mov rsi,inAscii;
    xor rax,rax;
    begin1:
    cmp byte[rsi],0xA;	//Compare With New Line
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
ret;


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
ret;
