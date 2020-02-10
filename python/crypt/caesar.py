#!/usr/bin/env python3
try:
  def caesar(input):
    if isinstance(input, str):
      output = []
      for character in input:
        value = ord(character)
        if value is in range(20,95): # (unicode decimal) make language adjustments here
          
        output.append(character)
      return output
    else:
      raise ValueError("input must be a string!")
except:
  print("An error has occurred.") 
else:
  print("Cipher complete.")
