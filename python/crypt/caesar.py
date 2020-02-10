#!/usr/bin/env python3
try:
  def caesar(input):
    if isinstance(input, str):
      output = []
      for character in input:
        output.append(character)
      return output
    else:
      raise ValueError("input must be a string!")
except:
  print("An error has occurred.") 
else:
  print("Cipher complete.")
