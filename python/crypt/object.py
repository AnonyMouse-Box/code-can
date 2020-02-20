#!/usr/bin/env python3
import uuid
from . import super
from . import sub

def __generateID(type):
  check = True
  while check == True
    id = uuid.uuid4()
    check = id in type.dict
  return id;
  
def createObject(type):
  name = __generateID(type)
  return type(name);

superclass.dict = {}
subclass.dict = {}
