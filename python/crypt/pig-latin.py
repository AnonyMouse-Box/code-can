#!/usr/bin/env python3
from . import ascii

def encrypt_pig_latin(value):
  if isinstance(value, str):
    word_array = value.split()
    space = " "
    new_array = []
    for word in word_array:
      word_beginning = word[0]
      if ascii.is_vowel(word_beginning) == True:
        new_word = word + "yay"
      else:
        n = 1
        for letter in word:
          check_letter = word[n]
          if ascii.is_vowel(check_letter) == True:
            new_word = word[n:] + word_beginning + "ay"
            break
          word_beginning += check_letter
          n += 1
          if n > len(word):
            new_word = word
          continue
      new_array.append(new_word)
      continue
    return space.join(new_array)
  else:
    raise ValueError("not a string")
  return
