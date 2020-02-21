#!/usr/bin/env python3
import uuid
from . import caesar
#from . import frequency

caesar.dict = {}
#frequency.dict = {}

class superclass(object):
  def __init__(self, name):
    self.name = name
    superclass.dict[name] = self
    return;

def __generateID(type):
  check = True
  while check == True
    id = uuid.uuid4()
    check = id in type.dict
  return id;
  
def createObject(type):
  name = __generateID(type)
  return type(name);
