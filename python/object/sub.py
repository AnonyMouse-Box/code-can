class subclass(superclass):
  def __init__(self, name):
    self.name = name
    subclass.dict[name] = self