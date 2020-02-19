#!/usr/bin/env python3
class caesar:
  plainUpper = [chr(i) for i in range(ord('A'), ord('Z') + 1)]
  plainLower = plainUpper[:]
  for value in plainLower:
    plainLower[plainLower.index(value)] = value.lower()
  digits = [chr(i) for i in range(ord('0'), ord('9') + 1)]
  plainText = plainUpper[:]
  plainText.append(plainLower[:])
  
  def rotate(charset, offset):
    while offset < 0:
      offset += len(charset)
    offset = offset % len(charset)
    translation = charset[offset:] + charset[:offset]
    return translation
  
  def caesar(text, rotation, flagDigits):
    if isinstance(text, str):
      if isinstance(rotation, int):
        if isinstance(flagDigits, bool):
          cipherUpper = rotate(plainUpper, rotation)
          cipherLower = rotate(plainLower, rotation)
          cipherTable = cipherUpper[:]
          cipherTable.append(cipherLower[:])
          if flagDigits = True:
            plainText.append(digits[:])
            cipherDigits = rotate(digits, rotation)
            cipherTable.append(cipherDigits[:])
          cipher = []
          textList = list(text)
          for character in textList:   
            if character in plainText:
              newCharacter = cipherTable[plainText.index(character)]
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
  
  def uncaesar(text, rotation, flagDigits):
    decipher = caesar(text, rotation * -1)
    return decipher
