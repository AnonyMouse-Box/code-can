#!/usr/bin/env python3
import uuid
import random

from . import coin

def __generateID(type):
  check = True
  while check == True
    id = uuid.uuid4()
    check = id in type.dict
  return id;

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
  
class die:
  def __init__(self, name, start, stop, step):
    self.name = name
    die.dict[name] = self
    self.faces = int((stop - start) / step)
    self.weights = {a = 1 for a in range(start, stop, step)}    
    return;
    
  def setWeight(self, value, weight):
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

def createCoin():
  name = __generateID(coin)
  return coin(name);

def createDie(start, stop, step):
  name = __generateID(die)
  return die(name, start, stop, step);

def createSimpleDie(sides):
  return createDie(0, sides, 1);

def flipCoins(self, quantity):
  coins = [self.__flipCoin() for a in range(quantity)]
  return coins;

def rollDice(self, quantity):
  dice = [self.__rollDie() for a in range(quantity)]
  return dice;

def weightedCoin(self, heads, tails, clumsy):
  self.__setHeads(heads)
  self.__setTails(tails)
  self.__setClumsy(clumsy)
  return;

coin.dict = {}
die.dict = {}