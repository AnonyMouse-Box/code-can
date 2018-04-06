/* Program for performing a Caesar Cipher to a string - TBC */
  .global _start
_start:
_read:
  MOV R7, #3        @ Syscall number
  MOV R0, #0        @ Stdin is keyboard
  MOV R2, #1        @ read first character
  LDR R1,=string    @ string placed at string:
  SWI 0
/* need to store additional value (1-26) as R3 */

/* needs to be: 40<x<5B (send to lower) or 60<x<7B
_errchk0:
  CMP R1, 0x40
  B LE _error
  CMP GT R1, 0x5B
  B GE _errchk1
  B LT _lower

_errchk1:
  CMP R1, 0x60
  B LE _error
  CMP GT R1, 0x7B
  B GE _error
  B LT _cipher
  */

_lower:
  LDR R1,=string      @ address of char
  LDR R4, [R1]        @ load it into R4
  ORR R4, R4, #0x20   @ change case
  STR R4, [R1]        @ write char back

_cipher:
  ADD R5, R1, R3        @ add cipher shift
  SUB S R6, R5, 0x7A    @ subtract z with flags
  ADD GT R1, R6, 0x60   @ if R6>0 add a-1
  MOV LE R1, R5         @ if R6<=0 store R5
/* check writing to R1 in this way has intended effect */

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
