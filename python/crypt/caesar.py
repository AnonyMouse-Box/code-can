#!/usr/bin/env python3
try:
  digits = (48,58) # (unicode decimal)
  upper = (65,91) # (unicode decimal) make uppercase language adjustments here
  lower = (97,123) # (unicode decimal) make lowercase language adjustments here
  
  def caesar(input):
    if isinstance(input, str):
      output = []
      for character in input:
        value = ord('character')
        if value is in range(digits): # scrambles digits
          newCharacter = character
        elif value is in range(upper): 
          newCharacter = character
        elif value is in range(lower): 
          newCharacter = character
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
