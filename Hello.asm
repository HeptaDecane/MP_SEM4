section.data                                                                    ;data segment
    msg: db 'Hello, world!',10                                                  ;String
    len: equ $ - msg                                                            ;Length of the String

section.text                                                                    ;code segment
    global _start                                                               ;must be declared for linker (ld)
    _start:                                                                     ;tells linker entry point
    
        mov eax,4                                                               ;system call number (sys_write)
        mov ebx,1                                                               ;file descriptor (stdout)
        mov edx,len                                                             ;message length
        mov ecx,msg                                                             ;message to write
        int 0x80                                                                ;call kernel

        mov eax,1                                                               ;system call number (sys_exit)
        mov ebx,0                                                               ;error code
        int 0x80                                                                ;call kernel
