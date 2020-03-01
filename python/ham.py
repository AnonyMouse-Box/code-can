#!/usr/bin/env python3


class ham(object):
  def __perfect(): # build a list of perfect codes
    perfect = []
    n = 16 # make tunable
    while n > 2: # make tunable
      perfect.append(2**n - 1 - n)
      n -= 1
    return perfect;
      
  def __calcBits(raw): # calculate the most efficient number of bits
    perfect = self.__perfect()
        remainder = []
    for value in perfect:
      remainder.append(raw % value)
    if min(remainder) is 0:
      closest = 0
    else:
      closest = max(remainder)
    i = 0
    clean = remainder[:]
    for item in remainder:
      if item is closest:
        if i > 0:
          clean[remainder.index(item)] = None
        i += 1
    output = perfect[clean.index(closest)]
    return output;
  
  def __code(bits): # calculate number of code bits
    code = []
    x = 1
    while x <= bits:
      code += x
      x *= 2
    return code;
  
  def __explode(): # explode code bits list into a matrix of the values they validate
    for value in self.code:
      item = [] # set up list for each codebit consider how to store
    for n in range(self.bits + 1):
      value = n
      while value > 0:
        p = 0
        while 2**p <= value:
          p + 1
        p - 1
        value -= 2**p
        log = 2**p # log n against 2**p list
    return output;  
  
  def __bits(bits): # define the code variables
    if isinstance(bits, int):
      self.bits = bits
      self.code = self.__code(bits)
      self.parity = self.__explode()
      self.data = self.bits - len(self.code)
    else:
      raise TypeError("no. of bits must be an integer!")
    return;
  
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
  
  def ham(raw, bits = None): # take in raw data and turn it into a coded list
    if bits is None:
      bits = self.__calcBits(raw)
    self.__bits(bits)
    split = self.__split(raw)
    padded = split[:-1] + self.__pad(split[-1])
    parity = self.__calcParity(padded)
    output = self.__insert(split, parity)
    return output;
  
  def deham(array): # take in a coded list and turn it into raw data
    self.__bits(len(array[0]))
    valid = self.__validate(array)
    corrected = self.__correct(array, valid)
    removed = self.__remove(array)
    output = ''.join(removed)
    return output;
