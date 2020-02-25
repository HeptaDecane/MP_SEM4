global fileDescriptor,char,buffer,lenText;
extern _TextCount;

%include "macro.asm"

section .data
    dash: db 10,"----------------------------------------------------------",10;
    lenDash: equ $-dash;

    reqFile: db "Enter File Name (with extension): ";
    lenReqFile: equ $-reqFile;

    reqChar: db "Enter Character to Search: ";
    lenReqChar: equ $-reqChar;

    errMsg: db "File Opening Error!";
    lenErrMsg: equ $-errMsg;

    space: db " ";
    newLine: db 10d;

section .bss
    buffer: resb 8192;
    lenBuffer: equ $-buffer;

    fileName: resb 64;
    char: resb 2;
    fileDescriptor: resq 1;
    lenText: resq 1;

section .text
    global _start
    _start:
        print dash,lenDash;

        print reqFile,lenReqFile;
        read fileName,64;

        dec rax;    //String Length in RAX on SYS_READ call
        mov byte[fileName+rax],0;

        print reqChar,lenReqChar;
        read char,2;

        fopen fileName;     //File-Descriptor is Stored in RAX on SYS_OPEN call
        cmp rax,-1d;        //-1 is returned to RAX in Case of File Opening Error
        jle error;          // jle is used for Signed Comparison
        mov [fileDescriptor],rax;

        fread [fileDescriptor],buffer,lenBuffer;
        mov [lenText],rax;      //String Length in RAX on SYS_READ call

        call _TextCount;
        jmp exit

        error:
        print errMsg,lenErrMsg;

        exit:
        print dash,lenDash;
        fclose [fileDescriptor]
        mov rax,60;
        mov rdi,0;
        syscall;
