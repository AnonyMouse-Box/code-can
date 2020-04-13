#!/usr/bin/env python3
from uuid import uuid

def __generateID(type):
  check = True
  while check == True:
    id = uuid4()
    check = id in type.dict
  return id

def appendDigits(n, base):
  new = []
  for item in base:
    for value in range(n):
      if len(item) > 0 and (value in item or value + 1 == item[-1] or value - 1 == item[-1]):
        continue
      new.append(item + [value,])
  return new

def calculateSetOfSets(n):
  base = ([],)
  for value in range(n):
    base = appendDigits(n, base)
  return base

class board(object):
  def __init__(self, name, width, height, queens):
    if queens > width or queens > height:
      print("too many queens")
      return
    elif height > width:
      temp = height
      height = width
      width = temp
    self.name = name
    board.dict[name] = self
    self.width = width
    self.height = height
    self.queens = queens
    return
  
  def calculateSets(self):
    self.sets = calculateSetOfSets(self.queens)
    return

def queens(n):
  if isinstance(n, int):
    name = __generateID(board)
    this = board(name, n, n, n)
    answer = this.calculateSets()
    return answer
  else:
    return "not an integer"

board.dict = {}
print(queens(4))
