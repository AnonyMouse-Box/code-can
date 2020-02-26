#!/usr/bin/env python3

class ham(object):
  def __init__(self, bits = self.__calcBits()):
    if isinstance(bits, int):
      self.bits = bits
      self.code = self.__code(bits)
      self.data = self.bits - self.code
    else:
      raise TypeError('total no. of bits must be an integer')
    return;
  
  def __calcBits(): # calculate the most efficient number of bits
    return output;
  
  def __code(bits): # calculate number of code bits
    return output;
  
  def __split(raw): # split binary into list of data bit segments
    output = []
    while raw is not "":
      output += raw[:self.data]
      raw = raw[self.data:]
    return output;
  
  def __pad(raw): # pad the last data bit segment to correct length
    while len(raw) is not self.data:
      raw += "0"
    return raw;
  
  def __calcParity(array): # calculate the parity bits required for each segment
    return output;
  
  def __insert(array, parity): # combine the code and data bits
    return output;
  
  def __validate(array): # check each of the parities
    return output;
  
  def __correct(array, valid): # correct any errors found
    return output;
  
  def __remove(array): # remove the code bits
    return output;
  
  def __concatenate(array): # concatenate the list into raw data
    return output;
  
  def ham(raw): # take in raw data and turn it into a coded list
    split = self.__split(raw)
    padded = split[:-1] + self.__pad(split[-1])
    parity = self.__calcParity(padded)
    output = self.__insert(split, parity)
    return output;
  
  def deham(array): # take in a coded list and turn it into raw data
    self.bits = len(array[0])
    valid = self.__validate(array)
    corrected = self.__correct(array, valid)
    removed = self.__remove(array)
    output = self.__concatenate(removed)
    return output;
