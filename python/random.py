#!/usr/bin/env python3
import random

class coin:
  def __init__(self):
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
  

class die:
  def __init__(self, start, stop, step):
    self.faces = int((stop - start) / step)
    self.weights = {a = 1 for a in range(start, stop, step)}    
    return;
    
  def __setWeight(self, value, weight):
    self.weights[value] = weight
    return;
    
  def __rollDie(self):
    print("you roll a D{0}".format(self.faces))
    for a in self.weight.values():
      n += a
    pseudodie = random.randrange(n)
    for key, value in self.weight.items():
      valueSum += value
      if pseudodie <= valueSum:
        result = key
        print("you rolled a {0}".format(result))
        break
    return result;


def flipCoins(self, quantity):
  coins = [self.__flipCoin() for a in range(quantity)]
  return coins;

def weightedCoin(self, heads, tails, clumsy):
  self.__setHeads(heads)
  self.__setTails(tails)
  self.__setClumsy(clumsy)
  return;

def rollDice(self, quantity):
  dice = [self.__rollDie() for a in range(quantity)]
  return dice;