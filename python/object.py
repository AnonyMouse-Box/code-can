#!/usr/bin/env python3

import uuid

def __generateID(type):
  check = True
  while check == True
    id = uuid.uuid4()
    check = id in type.dict
  return id;

class item(object):
  def __init__(self, name):
    self.name = name
    item.dict[name] = self
    return;
  
def createObject(type):
  name = __generateID(type)
  return type(name);

item.dict = {}