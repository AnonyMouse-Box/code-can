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

def caesar(text, rotation, flag):
  if isinstance(text, str):
    if isinstance(rotation, int):
      if isinstance(flag, bool):
        cipherText = rotate(plainUpper, rotation)
        cipherDigits = rotate(digits, rotation)
        cipher = []
        textList = list(text)
        for character in textList:   
          if character in digits:
            if flag == True:
              newCharacter = cipherDigits[digits.index(character)]
            else:
              newCharacter = character
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
        raise TypeError("flag must be boolean!")
    else:
      raise TypeError("rotation must be an integer!")
  else:
    raise TypeError("input must be a string!")

def uncaesar(text, rotation, flag):
  decipher = caesar(text, rotation * -1)
  return decipher
