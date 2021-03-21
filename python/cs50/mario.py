#!/usr/bin/env python3
from cs50 import get_int

n = 0
while n not in range(1, 9):
    n = get_int("Height: ")

for i in range(n):  # row iterator
    for j in range(2 * n + 2):  # column iterator
        if i + j < n - 1 or j == n or j == n + 1:  # overrides with spaces
            print(end=" ")
        elif not j - i > n + 2:  # print hash everywhere else except once pyramid is completed
            print(end="#")
    print()