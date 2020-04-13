#!/usr/bin/env python3
def primitive(x):
  new =[]
  for m in range(1, x):
    n = int((x / (2*m)) - m)
    if m > n and n > 0 and (m % 2 == 0 or n % 2 == 0):
      a = int(m*m - n*n)
      b = int(2*m*n)
      c = int(m*m + n*n)
      if a > 0 and b > 0 and c > 0 and a*a + b*b == c*c:
        values = [a, b, c]
        new.append(values)
  return new

def pythagoreanTriple(x):
  if isinstance(x, int) and x > 0:
    triples = primitive(x)
    solutions = []
    for item in triples:
      a = item[0]
      b = item[1]
      c = item[2]
      for k in range(1, x):
        if k*a + k*b + k*c == x:
          values = [k*a, k*b, k*c]
          solutions.append(values)
    if len(solutions) > 0:
      for item in solutions:
        print("{0} + {1} + {2} = {3}".format(item[0],item[1],item[2],x))
    else:
      print("No triple")
  else:
    raise ValueError("not a positive integer")
  return
