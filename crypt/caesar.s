/* Program for performing a Caesar Cipher to a string */
  .global _start
_start:
_read:
  MOV R7, #3        @ Syscall number
  MOV R0, #0        @ Stdin is keyboard
  MOV R2, #1        @ read first 1 characters
  LDR R1,=string    @ string placed at string:
  SWI 0

_write:
  MOV R0, #1
  MOV R2, #1
  MOV R7, #4
  SWI 0
  MOV PC, LR
