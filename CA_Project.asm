.model small
.stack 100h
.data
    
    ;OpenMenu 
    msg0 db 10,13,'      ///////////////----WELCOME----/////////////////          $'
    msg1 db 10,13,'-----  To Select Number of Names press 1                  -----$'
    msg2 db 10,13,'-----  To Enter Names press 2                             -----$'
    msg3 db 10,13,'-----  To Perform Ascending/Descending sorting press 3/4  -----$'
    msg4 db 10,13,'-----  To Display sorted Names press 5                    -----$' 
    msg5 db 10,13,'-----  To exit press 6                                    -----$'
    msg6 db 10,13,'       Please select...                                        $' 
    msg7 db 10,13,'                                                               $' 
    msg8 db 10,13,'Press space bar to return to OpenMenu $'                           
    msg9 db 10,13,'     Enter Number of Names to be displayed:$                    '
    msg10 db 10,13,' You need to set Number and Length of Names first             $'
    msg11 db 10,13,' You need to Enter The names first                             $'
    
                      
    error_msg db 10,13,'     wrong input, try again$'
    newline db 10,13, '                        $'
    Length_names db 10,13,  '     Enter the Lengnth of a Name(1-99): $'
    Num_names_msg db 10,13, '     Enter the Number of Names(1-99):$'
    
    names_msg db 10,13,     '     Enter the Names:- $'
    Entered_names_msg db 10,13,  '     Entered Names;-$'       
    
    timer db ?
    Number_Names db ?  
    
    element_size    equ 20h
    array_size      equ 400h  
    
    
    
    message  db '     -->$' 
  
    buffer   db ?          
             db  ?           
             db 200 dup (?)
       
    buffer1 db ?            

  
    array    db array_size dup('*')
             db '$'

 
    array_position dw ?
   
.code 

          mov ax,@data 
          mov ds,ax
          mov es,ax 
          
         add_new_line macro
            mov dl, 13
            mov ah, 2
            int 21h   
            mov dl, 10
            mov ah, 2
            int 21h      
            endm
            
          
;**********  Displey OpenMenu  *********** 


          mov dx, offset msg0
          mov ah, 9
          int 21h 
          
          add_new_line
          
    msgs: mov dx, offset newline
          mov ah, 9
          int 21h
   
   
          mov dx, offset msg1
          mov ah, 9
          int 21h 
          
          mov dx, offset msg2
          mov ah, 9
          int 21h 
          
          mov dx, offset msg3
          mov ah, 9
          int 21h 
          
          mov dx, offset msg4
          mov ah, 9
          int 21h 
          
          
          mov dx, offset msg5
          mov ah, 9
          int 21h 
          
          mov dx, offset newline
          mov ah, 9
          int 21h
          
          mov dx, offset msg6
          mov ah, 9
          int 21h
          

          
          
;*********  Jumbs  **************** 


          mov ah,1
          int 21h
          mov bh,al
          sub bh,30h
          
          
          cmp bh,1
          je Number_Length_Names
          
          cmp bh,2
          je s2
          
          cmp bh,3
          je ascending
          
          cmp bh,4
          je descinding
          
          cmp bh,5
          je display
    
          cmp bh,6
          je exit   
     
    
          jmp invalid
          
    
          
;**********  Number of Names  **************

      
          ;Length Of Names
          
    Number_Length_Names:
    
          mov dx, offset newline
          mov ah, 9
          int 21h 
          
          
          mov dx, offset Length_names
          mov ah, 9
          int 21h
                   
          xor cx,cx
          mov ax,0
          
          mov ah,1h
          int 21h
          sub al,30h 
          
          cmp al,10
          ja invalid 
          
           
          
          mov cl,al

          
          
          mov ah,1
          int 21h
           
          
          cmp al,13
          je d
          
          sub al,30h 
           cmp al,10
          ja invalid 
           
          mov bl,al
          mov al,10
          
          mul cl
          mov cl,al
          add cl,bl
          
          
         d:add cl,01h
           mov buffer,cl 
           mov buffer1,cl
          ;Number Of Names
          
          mov dx, offset Num_names_msg
          mov ah, 9
          int 21h        
                   
          xor bx,bx
          xor cx,cx
          mov ax,0
          
          mov ah,1h
          int 21h
          sub al,30h 
          cmp al,10
          ja invalid 
          
          mov cl,al


          mov ah,1
          int 21h
  
          
          cmp al,13
          je c
          
          sub al,30h 
           cmp al,10
          ja invalid 
          
          mov bl,al
          mov al,10
          
          mul cl
          mov cl,al
          add cl,bl
    
          
       c: mov Number_Names,cl 
          
          jmp msgs
          
          
          
;***********  NAMES  *********** 
      
      s2: mov dx, offset newline
          mov ah, 9
          int 21h
       
          mov dx, offset names_msg
          mov ah, 9
          int 21h
           
          
           
          
          add_new_line
           
          mov ax,0
          mov si,0 
          mov cx,0
           
          mov cl,Number_Names 
          cmp cl,0
          je abc
           
          lea di,array
          mov [array_position],di 

          
  
         input_loop:
          push cx        

  
          mov ah,09h
          lea dx,newline 
          int 21h

          mov ah,09h
          lea dx,message
          int 21h

  
          mov ah,0ah
          lea dx,buffer
          int 21h

  
          lea si,buffer
          inc si
          sub cx,cx
          mov cl,[si]   
          inc si

        string_transfer:
         lodsb         
         mov [di],al   
         inc di        
         loop string_transfer

         mov al,00h
         mov [di],al

         pop cx                

         mov di,[array_position]
         add di,element_size   
         mov [array_position],di

         loop input_loop       
           
  
          jmp msgs  
          
          
          
;*********  ASCENDING SORT  ******** 
         
    ascending: 
          
          mov cl,Number_Names 
          cmp cl,0
          je abc
          
          cmp array[0],'*'
          je abcd 
          
       mov bl,Number_Names
       mov timer,bl   
          
    q1:
        mov bx,0  
        mov di,0 
        dec timer
        cmp timer,0
        je msgs

  
    p1:

       mov al,array[bx]
       mov di,bx 
       mov dl,array[di+20h]

       cmp dl,'*'
       je q1 
       cmp al,dl
       ja exch1
 
       add bx,20h
 
       jmp p1

    exch1:

       mov si,di
       mov cl,buffer1 
       push cx
    cc:
       mov al,array[si] 
       xchg al,array[si+20h]
       mov array[si],al
       inc si 
    
     
     loop cc
      
      add bx,20h

      jmp p1 


  
             
        
        
;*********  DESCENDING SORT  ******** 
           
    descinding:
        
        
          mov cl,Number_Names 
          cmp cl,0
          je abc
          
          cmp array[0],'*'
          je abcd 
        
       mov bl,Number_Names
       mov timer,bl   
          
            
    q2:
    
        mov bx,0  
        mov di,0 
        dec timer
        cmp timer,0
        je msgs
  
    p2:

      mov al,array[bx]
      mov di,bx 
      mov dl,array[di+20h]

      cmp dl,'*'
      je q2 
      cmp al,dl
      jb exch2

      add bx,20h
  
      jmp p2

 exch2:

      mov si,di
      mov cl,buffer1 
      push cx 
      
  ccc:  
  
    mov al,array[si] 
    xchg al,array[si+20h]
     mov array[si],al
    inc si 
    
     
     loop ccc 
  
  
     add bx,20h

      jmp p2 


 
          
          
;************  DISPLAY OUTPUT  ***************

          
      display: 
      
             add_new_line

            
             
          mov cl,Number_Names 
          cmp cl,0
          je abc
          
          cmp array[0],'*'
          je abcd
          
           mov dx, offset msg9
             mov ah, 9
             int 21h 
             
             mov ah,1h
             int 21h
             sub al,30h
            
          
             mov cl,al
 
             mov ah,1
             int 21h 
          
             cmp al,13
             je dd
          
             sub al,30h
           
             mov bl,al
             mov al,10
          
             mul cl
             mov cl,al
             add cl,bl
          
          
          dd:
             cmp cl, Number_Names
             ja invalid
             
             add_new_line
             
             mov dx, offset Entered_names_msg
             mov ah, 9
             int 21h
             add_new_line 
              
             
             lea si,array
             mov [array_position],si ; 
  
             
            output_loop:
             push cx          
             lea di,buffer 
             
            string_transfer2:
            
             lodsb            ;
             or al,al         
             jz end_string_transfer2
             
             mov [di],al      
             inc di           
             jmp string_transfer2

            end_string_transfer2:
             mov al,'$'       
             mov [di],al

             mov ah,09h
             lea dx,newline   
             int 21h

             lea dx,buffer    
             int 21h

             pop cx                 

             mov si,[array_position]
             add si,element_size    
             mov [array_position],si

             loop output_loop      
             
              add_new_line 
              
              
              mov dx, offset msg8
              mov ah, 9
              int 21h 
                      
        ee:   mov ah, 1 
              int 21h
                      
                      
              cmp al,32
              je msgs
              jmp ee
              
              

           
;**********  EXIT  ************


      exit:mov ah,4Ch
           int 21h 
           
;********* no input  ****************

           
     abc: mov dx, offset msg10
          mov ah, 9
          int 21h 
          
          jmp  Number_Length_Names
          
    abcd: mov dx, offset msg11
          mov ah, 9
          int 21h 
          
          jmp  s2   
          
;**********  INVALID INPUT  ************
          
   invalid:mov dx, offset newline
           mov ah, 9
           int 21h
           mov dx, offset error_msg
           mov ah, 9
           int 21h 
           mov dx, offset newline
           mov ah, 9
           int 21h
           jmp msgs 
           
           ends
          