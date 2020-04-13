#!/usr/bin/env python3

class frequencyHack(object):
  def __init__(self, name):
    self.name = name
    frequency.dict[name] = self
    return;

def frequency(name):
  return frequency.frequencyHack(name)
