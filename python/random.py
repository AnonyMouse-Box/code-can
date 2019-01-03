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

def __rollDie(sides):
  print("you roll a D{0}".format(sides))
  die = random.randrange(sides + 1)
  print("you rolled a {0}".format(die))
  return die;

def flipCoins(quantity):
  coins = [__flipCoin() for a in range(quantity)]
  return coins;

def rollDice(sides, quantity):
  dice = [__rollDie(sides) for a in range(quantity)]
  return dice;
