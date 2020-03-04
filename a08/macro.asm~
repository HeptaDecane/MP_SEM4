;Macros For a05A and a05B

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

%macro fopen 1
    mov rax,02;     //SYS_OPEN
    mov rdi,%1;     //file-name
    mov rsi,02;     //O_RDWR
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
