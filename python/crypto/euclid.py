#!/usr/bin/env python3


# euclid.py - A simple script to calculate the greatest common divisor of two numbers.
# Usage: euclid.py -f <file>

def egcd(a: int, b: int) -> tuple[int, int, int]:
    s,t,u,v = 0,1,1,0
    while a != 0:
        q, r = b//a, b%a
        m, n = s-u*q, t-v*q
        b,a,s,t,u,v = a,r,u,v,m,n
    gcd = b
    return gcd, s, t

def modInverse(a: int, m: int) -> int:
    g, s, t = egcd(m, a)
    if (g != 1):
        return -1
    else:
        inv = t % m
        return inv

def modDivide(a: int, b: int, m: int) -> int:
    a = a % m
    inv = modInverse(b, m)
    if(inv == -1):
        print("Division not defined")
    else:
        return (inv*a) % m

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='A simple script to calculate the greatest common divisor of two numbers.')
    parser.add_argument('-f', '--file', help='The file containing the numbers.', required=True, type=argparse.FileType('r'))
    args = parser.parse_args()

    file = args.file
    a, b = map(int, file.read().split())
    print(f'The greatest common divisor of {a} and {b} is {egcd(a, b)[0]}.')
    print('Done.')
