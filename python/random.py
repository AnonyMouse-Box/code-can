#!/usr/bin/env python3
import random

class coin:
  def __init__(self, name):
    self.name = name
  
  weightHeads = 1
  weightTails = 1
  
  def __flipCoin():
    print("you flip a coin")
    bool = random.randrange(self.weightHeads + self.weightTails)
    if bool == 1:
      print("it lands on heads")
      result = "heads"
    elif bool == 0:
      print("it lands on tails")
      result = "tails"
    else:
      print("you lost the coin")
      result = "lost"
    return result;
  

class die:
  def __init__(self, faces):
    self.weights = {a = 1 for a in range(faces)}    
    
  def __rollDie(start, stop, step):
    sides = int((stop - start) / step)
    print("you roll a D{0}".format(sides))
    result = random.randrange(start, stop, step)
    print("you rolled a {0}".format(die))
    return result;

def flipCoins(quantity):
  coins = [__flipCoin() for a in range(quantity)]
  return coins;

def rollDice(start, stop, step, quantity):
  dice = [__rollDie(start, stop, step) for a in range(quantity)]
  return dice;
