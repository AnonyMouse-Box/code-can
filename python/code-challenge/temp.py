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