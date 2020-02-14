#!/usr/bin/env python3
plainTextUpper = [chr(i) for i in range(ord('A'),ord('Z')+1)]
plainTextLower = [chr(i) for i in range(ord('a'),ord('z')+1)]
cipherText = plainTextUpper

def rotate(cipherTextList, rotation):
  for value in cipherTextList:
    newValue = chr(ord(value) + rotation)
    cipherTextList[cipherTextList.index(value)] = newValue
  return

def caesar(text, rotation):
  if isinstance(text, str):
    if isinstance(rotation, int):
      rotate(cipherText, rotation)
      cipher = []
      textList = list(text)
      for character in textList:
        if character in plainTextUpper or character in plainTextLower:
          newCharacter = cipherText[plainTextUpper.index(character.upper())]
          if character in plainTextLower:
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
