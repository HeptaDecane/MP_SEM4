;display procedure for 64bit
display:	
        mov rsi,char_answer+15
        mov rcx,16
        cnt:    mov rdx,0
                mov rbx,16h
                div rbx
                cmp dl,09h
                jbe add30
                add dl,07h
        add30:  add dl,30h
                mov [rsi],dl
                dec rsi
                dec rcx
                jnz cnt
        	scall 1,1,char_answer,16
		ret
		
;Explanation: https://omkarnathsingh.wordpress.com/2016/12/31/explanation-of-assembly-procedures/
