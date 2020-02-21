#!/usr/bin/env python3
class caesar:
  def __init__(self, rotation, flagDigits):
    if isinstance(rotation, int):
      if isinstance(flagDigits, bool):
        plainUpper = [chr(i) for i in range(ord('A'), ord('Z') + 1)]
        plainLower = plainUpper[:]
        for value in plainLower:
          plainLower[plainLower.index(value)] = value.lower()
        digits = [chr(i) for i in range(ord('0'), ord('9') + 1)]
        self.plainText = plainUpper[:]
        self.plainText += plainLower[:]
        cipherUpper = self.rotate(plainUpper, rotation)
        cipherLower = self.rotate(plainLower, rotation)
        self.cipherTable = cipherUpper[:]
        self.cipherTable += cipherLower[:]
        if flagDigits is True:
          self.plainText += digits[:]
          cipherDigits = self.rotate(digits, rotation)
          self.cipherTable += cipherDigits[:]
        return;
      else:
        raise TypeError("flag must be boolean!")
    else:
      raise TypeError("rotation must be an integer!")
  
  def rotate(self, charset, offset):
    while offset < 0:
      offset += len(charset)
    offset = offset % len(charset)
    translation = charset[offset:] + charset[:offset]
    return translation
  
  def encrypt(self, text):
    if isinstance(text, str):
      cipher = []
      textList = list(text)
      for character in textList:   
        if character in self.plainText:
          newCharacter = self.cipherTable[self.plainText.index(character)]
        else:
          newCharacter = character
        cipher.append(newCharacter)
        output = ''.join(cipher)
      return output
    else:
      raise TypeError("input must be a string!")
  
  def decrypt(self, text):
    decipher = self.encrypt(text, rotation * -1, flagDigits)
    return decipher
