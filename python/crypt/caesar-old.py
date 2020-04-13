#!/usr/bin/env python3
from . import ascii

def encrypt_caesar(value, number):
  if isinstance(value, str) and isinstance(number, int):
    decimal_array = ascii.string_to_decimal(value)
    new_array = []
    for item in decimal_array:
      new_item = item + number
      if new_item < 33:
        new_item += 94
      elif new_item > 126:
        new_item -= 94
      new_array.append(new_item)
    encrypted = ascii.decimal_to_string(new_array)
    return encrypted
  else:
    raise ValueError("requires a string and an integer")
  return

def decrypt_caesar(value, number):
  decrypted = encrypt_caesar(value, (number * -1))
  return decrypted
