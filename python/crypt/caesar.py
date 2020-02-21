#!/usr/bin/env python3
class caesarCrypt(crypt):
  def __init__(self, name, rotation, flagDigits):
    if isinstance(rotation, int):
      if isinstance(flagDigits, bool):
        self.name = name
        subclass.dict[name] = self
        plainUpper = [chr(i) for i in range(ord('A'), ord('Z') + 1)]
        plainLower = plainUpper[:]
        for value in plainLower:
          plainLower[plainLower.index(value)] = value.lower()
        digits = [chr(i) for i in range(ord('0'), ord('9') + 1)]
        self.plainText = plainUpper[:] + plainLower[:]
        cipherUpper = self.__rotate(plainUpper, rotation)
        cipherLower = self.__rotate(plainLower, rotation)
        self.cipherTable = cipherUpper[:] + cipherLower[:]
        if flagDigits is True:
          self.plainText += digits[:]
          cipherDigits = self.__rotate(digits, rotation)
          self.cipherTable += cipherDigits[:]
        return;
      else:
        raise TypeError("flag must be boolean!")
    else:
      raise TypeError("rotation must be an integer!")
  
  def __rotate(self, charset, offset):
    while offset < 0:
      offset += len(charset)
    offset = offset % len(charset)
    translation = charset[offset:] + charset[:offset]
    return translation
  
  def __translate(self, text, flagDecrypt):
    if isinstance(text, str):
      if isinstance(flagDecrypt, bool):
        translated = []
        textList = list(text)
        for character in textList:   
          if character in self.plainText:
            if flagDecrypt is False:
              newCharacter = self.cipherTable[self.plainText.index(character)]
            else:
              newCharacter = self.plainText[self.cipherTable.index(character)]
          else:
            newCharacter = character
          translated.append(newCharacter)
          output = ''.join(translated)
        return output
      else:
        raise TypeError("flag must be a boolean!")
    else:
      raise TypeError("input must be a string!")
    
  def encrypt(self, text):
    cipher = self.__translate(text, False)
    return cipher
  
  def decrypt(self, text):
    decipher = self.__translate(text, True)
    return decipher

def caesar(name):
  rotation = input('Rotation: ')
  flagDigits = 'null'
  while flagDigits is 'null':
    yesNo = input('Rotate Digits (y or n)? ')
    if yesNo is 'y':
      flagDigits = True
    elif yesNo is 'n':
      flagDigits = False
    else:
      flagDigits = 'null'
  return caesar.caesarCrypt(name, rotation, flagDigits)
