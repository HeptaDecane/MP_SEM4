section .data 
msg    : db "File does not exist ",0AH
len     : equ $-msg
msg1   : db "File successfully copied",0AH
len1   : equ $-msg1
msg2    : db "File successfully deleted!!!!",0AH
len2     : equ $-msg2
msg3     : db "Enter the data to be typed in the file",0AH
len3     : equ $-msg3
buffer   : times 1000 db ' '
filelen  : dq 0


section .bss
filedes_1  : resq 1
filedes_2  : resq 1
filename_1 : resb 16
filename_2 : resb 16
choice     : resb 8


section .txt
global _start
%macro print 2
 mov rax,1
 mov rdi,1
 mov rsi,%1
 mov rdx,%2
 syscall
%endmacro
%macro read 2
 mov rax,0
 mov rdi,1
 mov rsi,%1
 mov rdx,%2
 syscall
%endmacro



_start:

 pop rbx          ; REMOVE THE NUMMBER OF ARGUMENS FROM THE STACK
 pop rbx          ;REMOVE EXECUTABLE PROGRAM NAME FROM THE STACK
 
 pop rbx ; GET THE FIRST ARGUMENT 
 
 ;READ THE CHOICE i.e COPY OR DELETE OR TYPE
 mov [choice],rbx
 mov rsi,qword[choice]
 cmp byte[rsi],43H
 je copy
 cmp byte[rsi],44H
 je Delete
 jmp type

;---------------COPY FROM ONE FILE TO ANOTHER FILE-------------------------->
copy:
 pop rbx
 mov rsi,filename_1
up_1: mov al,byte[rbx]
 mov byte[rsi],al
 inc rsi
 inc rbx
 cmp byte[rbx],0H
 jne up_1
 
 
 
 pop rbx
 mov rsi,filename_2
up_2: mov al,byte[rbx]
 mov byte[rsi],al
 inc rbx
 inc rsi
 cmp byte[rbx],0H
 jne up_2
 
 
 ;OPENING FIRST FILE
  mov rax,2
  mov rdi,filename_1 ;FIRST FILE NAME
  mov rsi,2 ; WR MODE
  mov rdx,0777 ; Permissions given to the file user,Owner,group is read and write and execute
  syscall
 
 ;CHECKING IF FILE EXIST 
  bt rax,63
  jc NoFile
  mov [filedes_1],rax ; if exists the saving hte file descriptor
  
 ;OPENING SECOND  FILE
  mov rax,2
  mov rdi,filename_2 ;SECOND FILE NAME
  mov rsi,2  ; WR MODE
  mov rdx,0777 ; Permissions given to the file user,Owner,group is read and write and execute
  syscall
  
 ;CHECKING IF FILE EXIST 
  cmp rax,0
  jle NoFile
  mov [filedes_2],rax ; if exists the saving the file descriptor
 
 ;READING FIRST FILE
  mov rax,0
  mov rdi,qword[filedes_1]
  mov rsi,buffer
  mov rdx,100
  syscall 
  
 ;SAVING THE LENGHT OF FIRST FILE
  mov qword[filelen],rax
  
 ;WRITING TO SECOND FILE
 mov rax,1
 mov rdi,qword[filedes_2]
 mov rsi,buffer
 mov rdx,qword[filelen]
 syscall
 
 ;CLOSING THE FILES
 mov rax,3
 mov rdi,filedes_1
 syscall
 mov rax,3
 mov rdi,filedes_2
 syscall
 
 ;PRINTING MESSAGE
 print msg1,len1
 jmp exit
 

;<-----------------DELETING FILE-------------------------->

Delete :
 pop rbx 
 mov rsi,filename_1
up_3: mov al,byte[rbx]
 mov byte[rsi],al
 inc rsi
 inc rbx
 cmp byte[rbx],0H
 jne up_3
 
;DELETE SYSTEM CALL
 mov rax,87
 mov rdi,filename_1
 syscall
 
;PRINTING THE MESSAGE
 print msg2,len2
 jmp exit
 
;<------------------TYPE IN THE FILE ----------------------->
type :
;SAVING FILE NAME
 pop rbx
 mov rsi,filename_1
up_4: mov al,byte[rbx]
 mov byte[rsi],al
 inc rsi
 inc rbx
 cmp byte[rbx],0H
 jne up_4
 
;OPENING THE FILE
 mov rax,2
 mov rdi,filename_1 ;FIRST FILE NAME
 mov rsi,2  ; APPEND MODE
 mov rdx,0777 ; Permissions given to the file user,Owner,group is read and write and execute
 syscall
 
;CHECKING IF FILE EXIST 
 cmp rax,1
 je NoFile
 mov [filedes_1],rax
  
 
;READING THE INPUT FROM THE SCREEN
 print msg3,len3
 read buffer,1000
 

;WRITING TO THE FILE
 mov rax,1
 mov rdi,qword[filedes_1]
 mov rsi,buffer
 mov rdx,1000
 syscall 
 
;CLOSING THE FILES
 mov rax,3
 mov rdi,filedes_1
 syscall
 
 jmp exit



;<-------------------PRINT FILE------------------------> 
NoFile :
  print msg,len
  jmp exit 


;<--------------TERMINATING THE PROGRAM--------------->
exit:
 mov rax,60
 mov rdi,0
 syscall
