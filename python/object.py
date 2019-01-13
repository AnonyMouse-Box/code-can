#!/usr/bin/env python3
import uuid

def __generateID(type):
  check = True
  while check == True
    id = uuid.uuid4()
    check = id in type.dict
  return id;

class superclass(object):
  def __init__(self, name):
    self.name = name
    superclass.dict[name] = self
    return;

class subclass(superclass):
  sef __init__(self, name):
    self.name = name
    subclass.dict[name] = self
  
def createObject(type):
  name = __generateID(type)
  return type(name);

item.dict = {}