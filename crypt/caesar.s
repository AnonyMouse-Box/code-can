/* Program for performing a Caesar Cipher to a string */
.global _start
_start:
_read:
                    @ read syscall
  MOV R7, #3        @ Syscall number
  MOV R0, #0        @ Stdin is keyboard
  MOV R2, #5        @ read first 5 characters
  LDR R1,=string    @ string placed at string:
  SWI 0
