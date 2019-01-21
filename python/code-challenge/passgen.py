#!/usr/bin/env python3
import random
import string

def generatePassword(value):
  if isinstance(value, int) == False:
    return "not an integer"
  elif value < 8:
    return "password too short"
  elif value > 32:
    return "password too long"
  else:
    return ''.join(random.choices(string.ascii_uppercase + string.ascii_lowercase + string.digits + string.punctuation, k=value))

def checkPassword():
  password = input("Password:")
  length = 0
  upper = 0
  lower = 0
  digit = 0
  symbol = 0
  space = 0
  if len(password) > 7:
    length = 1
  for letter in password:
    if letter in string.ascii_uppercase:
      upper = 1
    elif letter in string.ascii_lowercase:
      lower = 1
    elif letter in string.ascii_digits:
      digit = 1
    elif letter in string.punctuation:
      symbol = 1
    elif letter in string.whitespace:
      space = 1
    continue
  sum = length + upper + lower + digit + symbol + space
  if sum == 6:
    strength = "excellent"
  elif sum == 5:
    strength = "very strong"
  elif sum == 4:
    strength = "strong"
  elif sum == 3:
    strength = "average"
  elif sum == 2:
    strength = "weak"
  elif sum == 1:
    strength = "very weak"
  else:
    strength = "terrible"
  print("\nyour password is {0}.".format(strength))
  return