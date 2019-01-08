#!/usr/bin/env python3
import random

class coin:
  def __init__(self, name):
    self.name = name
    self.weightHeads = 1
    self.weightTails = 1
  
  def __flipCoin(self):
    print("you flip a coin")
    pseudobool = random.randrange(self.weightHeads + self.weightTails)
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
  def __init__(self, name, faces):
    self.name = name
    self.weights = {a = 1 for a in range(faces)}    
    
  def __rollDie(self):
    sides = int((stop - start) / step)
    print("you roll a D{0}".format(sides))
    result = random.randrange(start, stop, step)
    print("you rolled a {0}".format(die))
    return result;


def flipCoins(name, quantity):
  coins = [__flipCoin(name) for a in range(quantity)]
  return coins;

def rollDice(name, quantity):
  dice = [__rollDie(name) for a in range(quantity)]
  return dice;
