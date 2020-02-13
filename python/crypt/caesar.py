#!/usr/bin/env python3
try:
  plainTextUpper = [chr(i) for i in range(ord('A'),ord('Z')+1)]
  plainTextLower = [chr(i) for i in range(ord('a'),ord('z')+1)]
  cipherText = plainTextUpper
  
  def rotate(cipherTextList, rotation):
    for value in cipherTextList:
      newValue = ord('value') + rotation
      cipherTextList[cipherTextList.index(value)] = newValue
    return cipherTextList
  
  def caesar(text, rotation):
    if isinstance(text, str):
      if isinstance(rotation, int):
        rotate(cipherText, rotation)
        cipher = []
        textList = list(text)
        for character in textList:
          if character is in plainTextUpper or character is in plainTextLower:
            -
            if character is in plainTextLower:
              -
          else:
            newCharacter = character
          cipher.append(newCharacter)
          output = ''.join(cipher)
        return output
      else:
        raise ValueError("rotation must be an integer!")
    else:
      raise ValueError("input must be a string!")
    
except:
  print("An error has occurred.") 
  
else:
  print("Cipher complete.")
