class die:
  def __init__(self, name, start, stop, step):
    self.name = name
    die.dict[name] = self
    self.faces = int((stop - start) / step)
    self.weights = {a = 1 for a in range(start, stop, step)}    
    return;
    
  def setWeight(self, value, weight):
    self.weights[value] = weight
    return;
    
  def __rollDie(self):
    print("you roll a D{0}".format(self.faces))
    for a in self.weight.values():
      n += a
    pseudodie = random.randrange(n)
    for key, value in self.weight.items():
      valueSum += value
      if pseudodie <= valueSum:
        result = key
        print("you rolled a {0}".format(result))
        break
    return result;

def createDie(start, stop, step):
  name = __generateID(die)
  return die(name, start, stop, step);

def createSimpleDie(sides):
  return createDie(0, sides, 1);

def rollDice(self, quantity):
  dice = [self.__rollDie() for a in range(quantity)]
  return dice;