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

def checkDiagonals(sets):
  return sets

def queens(n):
  sets = calculateSetOfSets(n)
  sets = checkDiagonals(sets)
  solutions = len(sets)
  print("There are {0} solutions\n".format(solutions))
  input("Would you like to see them?")
  return