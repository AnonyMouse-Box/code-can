#!/usr/bin/env python3
def isBinary(text):
  if isinstance(text, str):
    for letter in text:
      if letter == "1" or letter == "0":
        continue
      else:
        return False
    return True
  else:
    return "is not a string"