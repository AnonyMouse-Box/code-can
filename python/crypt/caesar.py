#!/usr/bin/env python3
try:
  def caesar(input):
    if isinstance(input, str):
      output = []
      for character in input:
        value = ord('character')
        if value is in range(48,58): # (unicode decimal) scrambles digits
          
        elif value is in range(65,91): # (unicode decimal) make uppercase language adjustments here
          
        elif value is in range(97,123): # (unicode decimal) make lowercase language adjustments here
          
        else:
          newCharacter = character
        output.append(newCharacter)
      return output
    else:
      raise ValueError("input must be a string!")
except:
  print("An error has occurred.") 
else:
  print("Cipher complete.")
