#!/usr/bin/env python3


# rotsploit.py - A simple python script to exploit the small keyspace of shift ciphers.
# Usage: python3 rotsploit.py -f <file> -r <rot>

def brute_rot26(cipher):
    for i in range(0, 26):
        plain = ''
        for c in cipher:
            if c.isalpha():
                if c.islower():
                    plain += chr((ord(c) - i - ord('a')) % 26 + ord('a'))
                else:
                    plain += chr((ord(c) - i - ord('A')) % 26 + ord('A'))
            else:
                plain += c
        print(f"ROT-{i}: {plain}\n")
    return

def brute_rot47(cipher):
    for i in range(0, 94):
        plain = ''
        for c in cipher:
            if c.isprintable():
                plain += chr((ord(c) - i - 33) % 94 + 33)
            else:
                plain += c
        print(f"ROT-{i}: {plain}\n")
    return

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='A simple python script to exploit the small keyspace of shift ciphers.')
    parser.add_argument('-f', '--file', help='The cipher text to decrypt.', required=True, type=argparse.FileType('r'))
    parser.add_argument('-r', '--rot', help='The ROT cipher to use.', default=26, type=int)
    args = parser.parse_args()

    file = args.file
    cipher = file.read().strip()
    if args.rot == 47:
        brute_rot47(cipher)
    else:
        brute_rot26(cipher)
    print('Done.')
