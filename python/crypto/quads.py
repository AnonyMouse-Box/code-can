#!/usr/bin/env python3


# quads.py - A simple script to calculate the roots of a quadratic equation.
# Usage: quads.py -f <file>

def criterion(n: int, p: int) -> int:
    return pow(n, (p-1)//2, p)

def tonelli_shanks(n: int, p: int, symbol: int) -> int:
    if symbol == 0:
        return 0
    if p % 4 == 3:
        return pow(n, (p+1)//4, p)

    q = p - 1
    s = 0
    while q % 2 == 0:
        q //= 2
        s += 1
    for z in range(2, p):
        if criterion(z, p) == p - 1:
            break
    c = pow(z, q, p)
    r = pow(n, (q+1)//2, p)
    t = pow(n, q, p)
    m = s
    t2 = 0
    while (t - 1) % p != 0:
        t2 = (t * t) % p
        for i in range(1, m):
            if (t2 - 1) % p == 0:
                break
            t2 = (t2 * t2) % p
        b = pow(c, 1 << (m - i - 1), p)
        r = (r * b) % p
        c = (b * b) % p
        t = (t * c) % p
        m = i
    return r

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description='A simple script to calculate the roots of a quadratic equation.')
    parser.add_argument('-f', '--file', help='The file containing the value and the modulus.', required=True, type=argparse.FileType('r'))
    args = parser.parse_args()

    file = args.file
    n, p = map(int, file.read().split())
    symbol = criterion(n, p)
    if symbol == p - 1:
        print('The equation has no roots.')
    else:
        print('The roots of the equation are:')
        root = tonelli_shanks(n, p, symbol)
        print(f"{root} and {p - root}")
    print('Done.')
