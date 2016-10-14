#64-bit assembly
ask: .asciz "Please input a non-negtive number:\n"
again: .asciz "lol a non-negtive number please:\n"
num: .asciz "%d"
rstring: .asciz "%d! = %d\n"

.global main

main:
  pushq %rbp              #push rbp into stack
  movq %rsp, %rbp         #initialize the base pointer

#printf("Please input a non-negtive number:\n");
  movq $0, %rax           #no vector register used in main
  movq $ask, %rdi         #load the string address
  call printf             #call printf

#scanf("%d",&n);
  subq $8, %rsp           #reserve stack space for variable
  leaq -8(%rbp), %rsi     #load the address of stack var in rsi
  movq $num, %rdi         #load the first argument of scanf
  movq $0, %rax           #no vector register used in scanf
  call scanf              #call scanf
  jmp .compare            #jump to compare
  
.again:                   #scan number again if input is negative
  movq $0, %rax
  movq $again, %rdi
  call printf

  leaq -8(%rbp), %rsi     
  movq $num, %rdi
  movq $0, %rax
  call scanf

.compare:
  movq -8(%rbp), %rax     #move n to rax
  cmpl $0, %eax           #because we use two's complements represent a number.Integer is 32 bits.
                          #when scanf pass a negtive number(-9), %eax(32) is (-9), %rax(64) is (MAX_INT-9)
  jl   .again             #jump if less than

# 2.
#  movl -8(%rbp), %eax
#  testl %eax, %eax
#  js .again
# 3.
#  movslq -8(%rbp), %rax  #sign extension 32-64
#  testq %rax, %rax       #compare bitwise and
#  js .again              #jump if signed
 
#call fac(int n);
  movq -8(%rbp), %rdi     #***move n to the first parameter
  call fac                #call fac

#printf("%d\n", result)
  movq %rax, %rdx         #move result to the third parameter
  movq $rstring, %rdi     #load the string address
  movq $0, %rax           #no vector register used in main
  call printf             #call printf

#exit program
  leave                   #let esp = rbp and pop rbp 
  ret                     #return

 #movq $0, %rdi           #load program exit code
 #call exit               #exit program

fac:
  pushq %rbp              #subroutine prologue
  movq %rsp, %rbp         #subroutine prologue
  
  subq $16, %rsp          #reserve stack place for variable 
  movq %rdi, -16(%rbp)    #move the second parameter to the stack
  cmpq $0, -16(%rbp)      #compare 0 with n 
  jne ifcode              #if not equal to 0, jump to ifcode

elsecode:
  movq $1, %rax           #move 1 to rax register
  jmp end                 #jump to end

ifcode:
  movq -16(%rbp), %rax    #move n to rax register
  decq %rax               #decrease rax by one
  movq %rax, %rdi         #move rax to the first parameter
  call fac                #call fac
  imulq -16(%rbp), %rax   #multiply n with fac(n-1)

end:
  movq -16(%rbp), %rsi    #move n to printf second parameter
  leave                   #epilogue 
  ret                     #epilogue


#specification

#int fac(int num);
#int main() {
#  int n;
#  printf("Please input a non-negtive number:\n");
#  scanf("%d",&n);
#  while(n < 0) {
#     printf("lol a non-negtive number please:\n");
#     scanf("%d", &n);
#  }
#  printf("%d!=%d\n", n, fac(n));
#}
#
#int fac(int n) {
#  int f;
#  if(n == 0) {
#    f = 1;
#  }
#  if(n > 0) {
#    f = fac(n - 1)*n;
#  }
#  return f;
#
