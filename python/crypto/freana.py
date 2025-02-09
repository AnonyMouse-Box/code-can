#!/usr/bin/env python3


# freana.py - A simple script to analyse letter frequency in a text file.
# Usage: freana.py -f <file> -s <skip>

def count_letters(text):
    from collections import Counter
    freq = Counter(char for char in text.upper() if char.isalpha())
    length = sum(freq.values())
    print('Letter frequency:')
    for k, v in freq.most_common():
        print(f"{k}: {(v/length)*100:.2f}")
    return

def skip_letters(input, skip):
    for i in range(skip):
        text = input[i::skip]
        count_letters(text)
    return

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='A simple script to analyse letter frequency in text.')
    parser.add_argument('-f', '--file', help='The file to analyse.', required=True, type=argparse.FileType('r'))
    parser.add_argument('-s', '--skip', help='The skip value for the text.', default=1, type=int)
    args = parser.parse_args()

    file, skip = args.file, args.skip
    input = file.read().strip()

    skip_letters(input, skip)
    print('Done.')
