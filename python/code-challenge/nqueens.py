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
  for value in range(n):
    base = appendDigits(n, base)
  return base

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
  diag = calculateDiagonalSets(n)
  for item in sets:
    for check in diag:
      double = False
      for i in range(2):
        increment = 0
        for value in range(n):
          if item[value] == check[value]:
            increment += 1
        if increment > 1:
          sets.pop(sets.index(item))
          double = True
          break
        check.reverse()
      if double == True:
        break
  return sets

def displaySolutions(sets):
  for value in range(len(sets)):
    item = sets[value]
    board = []
    print("[")
    for index in range(len(item)):
      line = []
      for digit in item:
        if index == digit:
          line.append(1)
        else:
          line.append(0)
      board.append(line)
      print(board[index])
    print("]\n")
  return

def queens(n):
  try:
    sets = calculateSetOfSets(n)
    sets = checkDiagonals(sets, n)
    solutions = len(sets)
  except:
    print("An error has occured, try a smaller value")
    raise
  print("There are {0} solutions\n".format(solutions))
  try:
    response = input("Would you like to see them? ")
    if response in ["y", "Y", "yes", "Yes", "YES", "yeah", "Yeah", "YEAH", "yea", "Yea", "YEA", "yep", "Yep", "YEP"]:
      print("\n")
      displaySolutions(sets)
    return
  except:
    print("Invalid input")
    raise
