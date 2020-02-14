#!/usr/bin/env python3
plainUpper = [chr(i) for i in range(ord('A'),ord('Z')+1)]
plainLower = plainUpper[:]
for value in plainLower:
  plainLower[plainLower.index(value)] = value.lower()

def caesar(text, rotation):
  if isinstance(text, str):
    if isinstance(rotation, int):
      translation = plainUpper[rotation:] + plainUpper[:rotation]
      cipher = []
      textList = list(text)
      for character in textList:
        if character in plainUpper or character in plainLower:
          newCharacter = translation[plainUpper.index(character.upper())]
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
