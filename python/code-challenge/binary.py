#!/usr/bin/env python3
def isBinary(text):
  for letter in text:
    if letter == "1" or letter == "0":
      continue
    else:
      return False
  return True