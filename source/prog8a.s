/* Using ORR to toggle a character case */
  .global _start
_start:
_read:              @ read syscall
  MOV R7, #3        @ Syscall number
  MOV R0, #0        @ Stdin is keyboard
  MOV R2, #1        @ read one character only
  LDR R1,=string    @ string at string:
  SWI 0

_togglecase:
  LDR R1, =string     @ address of char
  LDR R0, [R1]        @ load it into R0
  ORR R0, R0, #0x20   @ change case
  STR R0, [R1]        @ write char back

_write:             @ write syscall
  MOV R7, #4        @ Syscall number
  MOV R0, #1        @ Stdout is monitor
  MOV R2, #1        @ string is 1 char long
  LDR R1,=string    @ string at start:
  SWI 0

_exit:
  @ exit syscall
  MOV R7, #1
  SWI 0

.data
string: .ascii""
