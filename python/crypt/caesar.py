#!/usr/bin/env python3
try:
  numerals = [48,58] # (unicode decimal)
  big = [65,91] # (unicode decimal) make uppercase language adjustments here
  little = [97,123] # (unicode decimal) make lowercase language adjustments here
  digits = range(numerals[0],numerals[1])
  upper = range(big[0],big[1])
  lower = range(little[0],little[1])
  
  def rotate(character):
    return character
  
  def caesar(input):
    if isinstance(input, str):
      output = ""
      for character in input:
        value = ord('character')
        if value is in digits: # scrambles digits
          newCharacter = rotate(character)
        elif value is in upper: 
          newCharacter = rotate(character)
        elif value is in lower: 
          newCharacter = rotate(character)
        else:
          newCharacter = character
        output += newCharacter
      return output
    else:
      raise ValueError("input must be a string!")
    
except:
  print("An error has occurred.") 
  
else:
  print("Cipher complete.")
