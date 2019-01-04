#!/usr/bin/env python3
import random

def __flipCoin():
  print("you flip a coin")
  bool = random.randrange(2)
  if bool == 1:
    print("it lands on heads")
    coin = "heads"
  elif bool == 0:
    print("it lands on tails")
    coin = "tails"
  else:
    print("you lost the coin")
    coin = "lost"
  return coin;

def __rollDie(start, stop, step):
  print("you roll a D{0}".format(sides))
  die = random.randrange(start, sides + 1, step)
  print("you rolled a {0}".format(die))
  return die;

def flipCoins(quantity):
  coins = [__flipCoin() for a in range(quantity)]
  return coins;

def rollDice(start, stop, step, quantity):
  dice = [__rollDie(start, stop, step) for a in range(quantity)]
  return dice;
