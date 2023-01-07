#!/usr/bin/env python3
# aoc_day3.py

def main() -> int:
    # Open the file and read 3 lines at a time stripping the whitespace.
    with open('day3_input') as f:
        total = [0, 0]
        line_a, line_b, line_c = f.readline(), f.readline(), f.readline()
        while line_a != "" and line_b != "" and line_c != "":
            if line_a != "\n" and line_b != "\n" and line_c != "\n":
                rucksack_a = line_a.strip()
                rucksack_b = line_b.strip()
                rucksack_c = line_c.strip()


                # Iterate over items in each set and collect any shared between all three.
                shared_set = [["", "", ""], ""]
                for a, b, c in zip(rucksack_a, rucksack_b, rucksack_c):
                    if a in rucksack_b and a in rucksack_c and a not in shared_set[1]:
                        shared_set[1] += a
                    elif b in rucksack_a and b in rucksack_c and b not in shared_set[1]:
                        shared_set[1] += b
                    elif c in rucksack_a and c in rucksack_b and c not in shared_set[1]:
                        shared_set[1] += c

                # Split rucksacks into compartments and find shared item.
                a1, a2 = rucksack_a[:len(rucksack_a)//2], rucksack_a[len(rucksack_a)//2:]
                b1, b2 = rucksack_b[:len(rucksack_b)//2], rucksack_b[len(rucksack_b)//2:]
                c1, c2 = rucksack_c[:len(rucksack_c)//2], rucksack_c[len(rucksack_c)//2:]
                for a in a1:
                    if a in a2:
                        shared_set[0][0] += a
                        break
                for b in b1:
                    if b in b2:
                        shared_set[0][1] += b
                        break
                for c in c1:
                    if c in c2:
                        shared_set[0][2] += c
                        break

                # Iterate over the shared set and calculate priorities correcting for ASCII.
                for i in range(len(shared_set)):
                    for item in shared_set[i]:
                        if item.islower():
                            total[i] += ord(item) - 96
                        elif item.isupper():
                            total[i] += ord(item) - 38
            line_a, line_b, line_c = f.readline(), f.readline(), f.readline()
        print(f"Sum of misplaced item priorities: {total[0]}")
        print(f"Sum of badge priorities: {total[1]}")
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
