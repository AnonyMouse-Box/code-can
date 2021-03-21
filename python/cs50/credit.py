#!/usr/bin/env python3
from cs50 import get_string


def luhn(number):  # performs luhn algorithm check
    total = 0
    reverse = number[::-1]
    for i in range(len(reverse)):
        product = int(reverse[i])
        if i % 2 != 0:
            product *= 2
        total += product // 10
        total += product % 10
    if total % 10 == 0:
        return True
    return False


def validate(number):  # validates the card number
    length = len(number)
    if length in (13, 15, 16):
        output = luhn(number)
        if output is True:
            if length in (13, 16) and number[0] == '4':
                print("VISA")
                return
            elif length == 15 and number[0:2] in ("34", "37"):
                print("AMEX")
                return
            elif length == 16 and 50 < int(number[0:2]) < 56:
                print("MASTERCARD")
                return
    print("INVALID")
    return


if __name__ == "__main__":  # the core function
    number = get_string("Number: ")
    validate(number)