def appendDigits(n, base):
  new = []
  for item in base:
    for value in range(n):
      if value in item:
        continue
      new.append(item + [value,])
  return new

def calculateSetOfSets(n):
  base = ([],)
  for value in range(n):
    base = appendDigits(n, base)
  return base