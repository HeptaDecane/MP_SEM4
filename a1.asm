section	.data
global x
x:    
   db  2

sum: 
   db  0
   
section	.text
   global _start   ;must be declared for linker (ld)
	
_start:	

   mov  ebx,0h      ;EBX will store the sum


   add ebx,5h

done: 

   add   ebx, '0'
   mov  [sum], ebx ;done, store result in "sum"

display:

   mov  edx,1      ;message length
   mov  ecx, sum   ;message to write
   mov  ebx, 1     ;file descriptor (stdout)
   mov  eax, 4     ;system call number (sys_write)
   int  0x80       ;call kernel
	
   mov  eax, 1     ;system call number (sys_exit)
   int  0x80       ;call kernel


