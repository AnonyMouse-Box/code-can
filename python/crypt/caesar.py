#!/usr/bin/env python3
class caesar:
  def __init__(self, name):
    self.name = name
    self.plainUpper = [chr(i) for i in range(ord('A'), ord('Z') + 1)]
    self.plainLower = self.plainUpper[:]
    for value in self.plainLower:
      self.plainLower[self.plainLower.index(value)] = value.lower()
    self.digits = [chr(i) for i in range(ord('0'), ord('9') + 1)]
    self.plainText = self.plainUpper[:]
    self.plainText.append(self.plainLower[:])
  
  def rotate(self, charset, offset):
    while offset < 0:
      offset += len(charset)
    offset = offset % len(charset)
    translation = charset[offset:] + charset[:offset]
    return translation
  
  def caesar(self, text, rotation, flagDigits):
    if isinstance(text, str):
      if isinstance(rotation, int):
        if isinstance(flagDigits, bool):
          self.cipherUpper = rotate(self.plainUpper, rotation)
          self.cipherLower = rotate(self.plainLower, rotation)
          self.cipherTable = self.cipherUpper[:]
          self.cipherTable.append(self.cipherLower[:])
          if flagDigits is True:
            self.plainText.append(self.digits[:])
            self.cipherDigits = rotate(self.digits, rotation)
            self.cipherTable.append(self.cipherDigits[:])
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
          raise TypeError("flag must be boolean!")
      else:
        raise TypeError("rotation must be an integer!")
    else:
      raise TypeError("input must be a string!")
  
  def uncaesar(self, text, rotation, flagDigits):
    decipher = caesar(text, rotation * -1, flagDigits)
    return decipher
