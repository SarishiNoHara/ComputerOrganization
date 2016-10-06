mystring:  .asciz"assignment2: inout.s\n"
ask: .asciz "Please input a number:\n"
number: .asciz "%d\n"
  
	.global	main
main:
  movq  %rsp, %rbp        #initialize the base pointer
  
  movq $0, %rax           #no vector registers in use for printf
  movq $mystring, %rdi    #load the address of mystring
  call	printf            #call the printf routine
  call  inout             #call inout

  mov  $0, %rdi           #load program exit code
  call exit               #exit the program

inout:
  pushq %rbp              #push the base pointer
  movq  %rsp, %rbp        #copy the stack pointer to rbp
  
  movq $0, %rax           #ask user for a number
  movq $ask, %rdi
  call printf

#scanf("%d", &num)
  subq $8, %rsp           #reserve stack space for variable
  leaq -8(%rbp), %rsi     #load address of stack var in rsi &num
  movq $number, %rdi      #load first argument of scanf
  movq $0, %rax           #no vector register for scanf
  call scanf              #call scanf
 
  movq -8(%rbp), %rax     #reserve stack space for scanf return value 
  addq  $1, %rax          #add 1 to return value
  movq %rax, %rsi         #load the value to second parameter    
  movq $number, %rdi      #load the number
  call printf             #call printf

  movq  %rbp, %rsp        #clear the loacal value from the stack
  pop   %rbp              #restore the caller's base pointer
  ret
