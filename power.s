#64-bits assembly
mystring: .asciz "assignment3: power.s\n"
ask: .asciz "Please input the base and exp, split by space:\n"
number: .asciz "%d%d"
rvalue: .asciz "%d\n"
  
	.global	main
main:
  movq  %rsp, %rbp        #initialize the base pointer
  movq $0, %rax           #no vector registers in use for main
  movq $ask, %rdi         #load the string address
  call printf             #call printf ask user to input numbers 

#scanf("%d%d", &base, &exp) ask user to input two numbers split by space or enter
  subq $16, %rsp          #reserve stack space for variable
  leaq -16(%rbp), %rdx    #load address of stack var in rdx &exp
  leaq -8(%rbp), %rsi     #load address &base
  movq $number, %rdi      #load first argument of scanf
  movq $0, %rax           #no vector registers in use for scanf
  call scanf              #call scanf

#power1(int base, int exp) pass parameters
  movq -16(%rbp), %rax    #move exp value to rax register 
  movq %rax, %rsi         #move exp value to second parameter 
  movq -8(%rbp), %rax     #move base value to rax register
  movq %rax, %rdi         #load base value to first parameter     
  call power1             #call power1

#printf("%d", result)
  movq %rax, %rsi         #move the return value to result 
  movq $rvalue, %rdi      #load the string address 
  movq $0, %rax           #no vector registers in use for printf 
  call printf             #call printf

#exit program
  mov  $0, %rdi           #load program exit code
  call exit               #exit the program

power1:
  pushq %rbp              #subroutine prologue
  movq %rsp, %rbp         #subroutine prologue

  movq %rdi,-16(%rbp)     #move base to stack 
  movq %rsi,-24(%rbp)     #move exp to stack 
  movq $1,%rax            #total = 1
  jmp loop                #jmp to loop

loop:
  cmpq $0, -24(%rbp)      #compare 0 with exp
  jle  end                #if less and equal than 0, then jump to end 

  imulq -16(%rbp),%rax    #multiply base with total
  subq $1, -24(%rbp)      #exp value minus one 
  jmp loop                #jump to loop

end:
  leave                   #epilogue
  ret                     #return from power1

#specification

#int main() {
#  int base, exp;
#  printf("Please input the base and exp, split by space:");
#  scanf("%d%d", &base, &exp);
#  printf("%d\n", pow1(base, exp));
#}
#
#int pow1(int base, int exp) {
#  int total = 1;
#  while(exp--) {
#    total *= base;
#  }
#  return total;
#}