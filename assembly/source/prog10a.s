/**** Convert to binary for printing ****/
  .global _start
_start:
  MOV R6, #215          @ Number to print in R6
  MOV R10, #1           @ set up mask
  MOV R9, R10, LSL #31
  LDR R1, = string      @ Point R1 to string
  
_bits: