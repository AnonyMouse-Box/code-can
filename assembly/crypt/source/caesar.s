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

_errchk0:
  CMP R1, 0x40      @ Check not lower than A
  B LE _error       @ If false send error
  CMP GT R1, 0x5B   @ If true check not higher than Z
  B GE _errchk1     @ If false send to lowercase check
  B LT _lower       @ If true send for case lowering

_errchk1:
  CMP R1, 0x60      @ Check not lower than a
  B LE _error       @ If false send error
  CMP GT R1, 0x7B   @ If true check not higher than z
  B GE _error       @ If false send error
  B LT _cipher      @ If true send for ciphering

_error:

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
