/* Program for performing a Caesar Cipher to a string - TBC */
  .global _start
_start:
_read:
  MOV R7, #3        @ Syscall number
  MOV R0, #0        @ Stdin is keyboard
  MOV R2, #1        @ read first character
/* needs to be: 40<x<5B or 60<x<7B */
  LDR R1,=string    @ string placed at string:
  SWI 0

_lower:
  LDR R1,=string      @ address of char
  LDR R0, [R1]        @ load it into R0
  ORR R0, R0, #0x20   @ change case
  STR R0, [R1]        @ write char back

_cipher:
  ADD R0, R1, R2        @ add cipher shift
  SUB S R3, R4, 0x7A    @ subtract z with flags
  ADD GT R0, R3, 0x60   @ if R3>0 add a-1

_write:
  MOV R7, #4        @ Syscall number
  MOV R0, #1        @ Stdout is monitor
  MOV R2, #1        @ string is 1 chars long
  LDR R1,=string    @ string is located at string:
  SWI 0

_exit:
  MOV R7, #1
  SWI 0

.data
string:
.ascii " "
