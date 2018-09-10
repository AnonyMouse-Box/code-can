/* Program for performing a Caesar Cipher to a string - TBC */
  .global _start
_start:
_read:
  MOV R7, #3        @ Syscall number
  MOV R0, #0        @ Stdin is keyboard
  MOV R2, #1        @ read first character
  LDR R1,=string    @ character stored as R1
  SWI 0
  B _errup          @ move to uppercase check
/* need to store additional value (1-26) as R3 */

_errup:
  CMP R1, 0x40      @ Check against (A-1)
  B LE _error       @ If lower than 'A' send for error
  CMP GT R1, 0x5B   @ If greater than (A-1) check against (Z+1)
  B GE _errlow      @ If greater than 'Z' send to lowercase check
  B LT _lower       @ If less than (Z+1) send for case lowering

_errlow:
  CMP R1, 0x60      @ Check against (a-1)
  B LE _error       @ If lower than 'a' send for error
  CMP GT R1, 0x7B   @ If greater than (a-1) check against (z+1)
  B GE _error       @ If greater than 'z' send for error
  B LT _cipher      @ If less than (z+1) send for ciphering

_error:

_lower:
  LDR R1,=string      @ address of char
  LDR R4, [R1]        @ load it into R4
  ORR R4, R4, 0x20    @ change case
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
