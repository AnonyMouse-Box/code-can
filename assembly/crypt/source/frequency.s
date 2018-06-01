/* program for performing an alphabet frequency attack to break ciphers and basic encyption - TBC */
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
  B LT _cipher      @ If true send for decryption

_error:

_lower:
  LDR R1,=string      @ address of char
  LDR R4, [R1]        @ load it into R4
  ORR R4, R4, #0x20   @ change case
  STR R4, [R1]        @ write char back

_algorithm:
/* will focus on simply decrypting the most likely and leave dictionary resolving for later */
/* eta oin shr dlu cmf wyp vbg kjq xz */

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
