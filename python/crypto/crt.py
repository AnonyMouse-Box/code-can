#!/usr/bin/env python3


# crt.py - A simple script to solve the Chinese Remainder Theorem.
# Usage: crt.py -f <file>

def crt(equations: list[tuple[int, int]]) -> int:
    import euclid
    if len(equations) == 3 and euclid.egcd(equations[0][1], equations[1][1])[0] == 1 and euclid.egcd(equations[0][1], equations[2][1])[0] == 1 and euclid.egcd(equations[1][1], equations[2][1])[0] == 1:
        p = equations[0][1] * equations[1][1] * equations[2][1]
        x = 0
        for i in range(len(equations)):
            r = equations[i][0]
            m = p // equations[i][1]
            inv = euclid.modInverse(m, equations[i][1])
            if(inv == -1):
                print("Division not defined")
                return
            else:
                x += r * m * inv
        return x % p, p
    else:
        print('The moduli are not pairwise coprime.')
        return

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='A simple script to solve the Chinese Remainder Theorem.')
    parser.add_argument('-f', '--file', help='The file containing the equations.', required=True, type=argparse.FileType('r'))
    args = parser.parse_args()

    file = args.file
    equations = [tuple(map(int, line.split())) for line in file]
    result = crt(equations)
    print(f'The solution to the equations is {result[0]} mod {result[1]}.')
