#!/usr/bin/env python3

class superclass(object):
  def __init__(self, name):
    self.name = name
    superclass.dict[name] = self
    return;