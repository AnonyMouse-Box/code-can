/* Add two 64-bit numbers together */
  .global _start
_start:
  MOV R2, #0xFFFFFFFF   @ low half number 1
  MOV R3, #0x1          @ hi half number 1
  MOV R4, #0xFFFFFFFF   @ low half number 2
  MOV R5, #0xFF         @ hi half number 2
  ADDS R0, R2, R4       @ add low and set flags
  ADCS R1, R3, R5       @ add hi with carry
  
  MOV R7, #1            @ exit through syscall
  SWI 0
