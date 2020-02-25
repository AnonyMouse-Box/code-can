#!/usr/bin/env python3

class ham(object):
  def __init__(self, bits = 31):
    if isinstance(bits, int):
      self.bits = bits
      self.code = self.__code(bits)
    else:
      raise TypeError('total no. of bits must be an integer')
    return;
  
  def __code(bits): # calculate number of code bits
    return output;
  
  def __split(binary): # split binary into list of data bit segments
    data = binary[:]
    output = []
    while data is not "":
      output += data[:(self.bits - self.code)]
      data = data[(self.bits - self.code):]
    return output;
  
  def __pad(binary): # pad the last data bit segment to correct length
    return output;
  
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
  
  def ham(binary): # take in data and turn it into a coded list
    split = self.__split(binary)
    split += self.__pad(split[-1])
    parity = self.__calcParity(split)
    output = self.__insert(split, parity)
    return output;
  
  def deham(array): # take in a coded list and turn it into data
    self.bits = len(array[0])
    valid = self.__validate(array)
    corrected = self.__correct(array, valid)
    removed = self.__remove(array)
    output = self.__concatenate(removed)
    return output;
