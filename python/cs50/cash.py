#!/usr/bin/env python3
from cs50 import get_float


def change(number, value):  # function to calculate each coin
    increment = 0
    while number >= value:
        number -= value  # calculate new value
        increment += 1  # add an additional coin
    return number, increment


n = -1
while n < 0:
    n = get_float("Change owed: ")  # prompt for input

n *= 100  # turn into pennies
coins = 0
for i in [25, 10, 5, 1]:
    result = change(n, i)  # run function
    n = result[0]  # new n value
    coins += result[1]  # add the coins

print(coins)