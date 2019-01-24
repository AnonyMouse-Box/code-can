def appendDigits(n, base):
  new = []
  for item in base:
    for value in range(n):
      new.append(item + [value,])
  return new

def calculateSetOfSets(n):
  base = ([],)
  for value in range(n):
    base = appendDigits(n, base)
  return base