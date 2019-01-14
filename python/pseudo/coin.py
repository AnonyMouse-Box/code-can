#!/usr/bin/env python3
import random

class coin:
  def __init__(self, name):
    self.name = name
    coin.dict[name] = self
    self.weightHeads = 1
    self.weightTails = 1
    self.clumsy = 0
    return;
  
  def __setHeads(self, weight):
    self.weightHeads = weight
    return;
  
  def __setTails(self, weight):
    self.weightTails = weight
    return;
  
  def __setClumsy(self, weight):
    self.clumsy = weight
    return;
  
  def __flipCoin(self):
    print("you flip a coin")
    pseudobool = random.randrange(self.weightHeads + self.weightTails + self.clumsy)
    if pseudobool <= self.weightHeads:
      print("it lands on heads")
      result = "heads"
    elif pseudobool <= self.weightHeads + self.weightTails:
      print("it lands on tails")
      result = "tails"
    else:
      print("you lost the coin")
      result = "lost"
    return result;
  
def createCoin():
  name = __generateID(coin)
  return coin(name);

def flipCoins(self, quantity):
  coins = [self.__flipCoin() for a in range(quantity)]
  return coins;

def weightedCoin(self, heads, tails, clumsy):
  self.__setHeads(heads)
  self.__setTails(tails)
  self.__setClumsy(clumsy)
  return;
