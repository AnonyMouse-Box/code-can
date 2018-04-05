/* program for performing an alphabet frequency attack to break ciphers and basic encyption - TBC */
  .global _start
_start:
_read:
  MOV R7, #3        @ Syscall number
  MOV R0, #0        @ Stdin is keyboard
  MOV R2, #1        @ read first character
/* needs to be: 40<x<5B (send to lower) or 60<x<7B */
  LDR R1,=string    @ string placed at string:
  SWI 0

_lower:
  LDR R1,=string      @ address of char
  LDR R4, [R1]        @ load it into R3
  ORR R4, R4, #0x20   @ change case
  STR R4, [R1]        @ write char back

_algorithm:
/* will focus on simply decrypting the most likely and leave dictionary resolving for later */
/* etaoinshrdlucmfwypvbgkjqxz */

_write:
  MOV R7, #4        @ Syscall number
  MOV R0, #1        @ Stdout is monitor
  MOV R2, #1        @ string is 1 char long
  LDR R1,=string    @ string is located at string:
  SWI 0

_exit:
  MOV R7, #1
  SWI 0

.data
string:
.ascii " "
