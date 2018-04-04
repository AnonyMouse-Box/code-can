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

_write:
                    @ write syscall
  MOV R7, #4        @ Syscall number
  MOV R0, #1        @ Stdout is monitor
  MOV R2, #19       @ string is 19 chars long
  LDR R1,=string    @ string is located at string:
  SWI 0

_exit:
  @ exit syscall
  MOV R7, #1
  SWI 0

.data
string:
.ascii "Hello World String\n"
