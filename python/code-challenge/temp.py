def appendDigits(n, base):
  new = []
    for item in base:
      for value in range(n):
        new.append(item.append(value))
    return new

def calculateSetOfSets(n):
  base = ([],)
  for value in range(n):
    setOfSets = appendDigits(n, base)
  return setOfSets