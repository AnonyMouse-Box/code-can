#!/usr/bin/env python3
def string_to_decimal(value):
  if isinstance(value, str):
    decimal_array = []
    for letter in value:
      decimal_array.append(ord(letter))
    return decimal_array
  else:
    raise ValueError("not a string")
  return

def decimal_to_string(value):
  if isintance(value, list):
    sentence = ""
    for digit in value:
      if isinstance(digit, int):
        sentence += chr(digit)
        return sentence
      else:
        raise ValueError("not an integer")
  else:
    raise ValueError("not a list")
  return

def is_vowel(value):
  if isinstance(value, str) and len(value) == 1:
    vowels = [a,A,e,E,i,I,o,O,u,U,y,Y]
    if value in vowels:
      return True
    else:
      return False
  else:
    raise ValueError("not a letter")
  return
