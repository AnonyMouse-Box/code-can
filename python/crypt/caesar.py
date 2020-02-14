#!/usr/bin/env python3
plainUpper = [chr(i) for i in range(ord('A'), ord('Z') + 1)]
plainLower = plainUpper[:]
for value in plainLower:
  plainLower[plainLower.index(value)] = value.lower()
digits = [chr(i) for i in range(ord('0'), ord('9') + 1)]

def rotate(charset, offset):
  while offset < 0:
    offset += len(charset)
  offset = offset % len(charset)
  translation = charset[offset:] + charset[:offset]
  return translation

def caesar(text, rotation):
  if isinstance(text, str):
    if isinstance(rotation, int):
      cipherText = rotate(plainUpper, rotation)
      cipherDigits = rotate(digits, rotation)
      cipher = []
      textList = list(text)
      for character in textList:
        if character in digits:
          newCharacter = cipherDigits[digits.index(character)]
        elif character in plainUpper or character in plainLower:
          newCharacter = cipherText[plainUpper.index(character.upper())]
          if character in plainLower:
            newCharacter = newCharacter.lower()
        else:
          newCharacter = character
        cipher.append(newCharacter)
        output = ''.join(cipher)
      return output
    else:
      raise ValueError("rotation must be an integer!")
  else:
    raise ValueError("input must be a string!")
