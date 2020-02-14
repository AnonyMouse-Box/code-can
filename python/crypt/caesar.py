#!/usr/bin/env python3
plainTextUpper = [chr(i) for i in range(ord('A'),ord('Z')+1)]
plainTextLower = plainTextUpper[:]
for value in plainTextLower:
  plainTextLower[plainTextLower.index(value)] = value.lower()

def caesar(text, rotation):
  if isinstance(text, str):
    if isinstance(rotation, int):
      translation = plainTextUpper[offset:] + plainTextUpper[:offset]
      cipher = []
      textList = list(text)
      for character in textList:
        if character in plainTextUpper or character in plainTextLower:
          newCharacter = translation[plainTextUpper.index(character.upper())]
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
