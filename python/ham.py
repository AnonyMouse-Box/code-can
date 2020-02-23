#!/usr/bin/env python3

class ham(object):
  def __init__(self, bits = 31):
    if isinstance(bits, int):
      self.bits = bits
    else:
      raise TypeError('no. of bits must be an integer')
    return;
  
  def __split(binary):
    return output;
  
  def __pad(binary):
    return output;
  
  def __calcParity(array):
    return output;
  
  def __insert(array, parity):
    return output;
  
  def __validate(array):
    return output;
  
  def __correct(array, valid):
    return output;
  
  def __remove(array):
    return output;
  
  def ham(binary):
    split = self.__split(binary)
    split += self.__pad(split[-1])
    parity = self.__calcParity(split)
    output = self.__insert(split, parity)
    return output;
  
  def deham(array):
    self.bits = len(array[0])
    valid = self.__validate(array)
    corrected = self.__correct(array, valid)
    removed = self.__remove(array)
    output = self.__concatenate(removed)
    return output;
