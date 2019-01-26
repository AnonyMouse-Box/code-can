#!/usr/bin/env python3
def appendDigits(n, base):
  new = []
  for item in base:
    for value in range(n):
      if len(item) > 0 and (value in item or value == item[-1] - 1 or value == item[-1] + 1):
        continue
      new.append(item + [value,])
  return new

def calculateSetOfSets(n):
  base = ([],)
  try:
    for value in range(n):
      base = appendDigits(n, base)
    return base
  except:
    return "An error has occured, try a smaller value"

def calculateDiagonalSets(n):
  new = []
  construct = []
  for value in range(2*n - 1):
    construct.append(value)
    new.append(construct.copy())
  for value in range(len(new)):
    if len(new[value]) > n:
      new[value] = new[value][-n:]
    elif len(new[value]) < n:
      while len(new[value]) < n:
        new[value] = ["x"] + new[value]
    for item in range(len(new[value])):
      if isinstance(new[value][item], str):
        continue
      elif new[value][item] >= n:
        new[value][item] = "x"
  return new

def checkDiagonals(sets, n):
  calculateDiagonalSets(n)
  return sets

def displaySolutions(sets):
  return

def queens(n):
  sets = calculateSetOfSets(n)
  sets = checkDiagonals(sets, n)
  solutions = len(sets)
  print("There are {0} solutions\n".format(solutions))
  response = input("Would you like to see them? ")
  if response in ["y", "Y", "yes", "Yes", "YES", "yeah", "Yeah", "YEAH"]:
    displaySolutions(sets)
  return
