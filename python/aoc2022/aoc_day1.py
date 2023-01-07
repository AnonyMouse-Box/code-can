#!/usr/bin/env python3
# aoc_day1.py

def main() -> int:
    # Open input file and loop over lines until end.
    with open('day1_input') as f:
        elves = []
        total = 0
        line = f.readline()
        while line != "":

            # Tally up totals for each elf and append to list.
            if line != "\n":
                total += int(line.strip())
            else:
                elves.append(total)
                total = 0
            line = f.readline()

        # Make a copy of the list to retain positioning as max is removed for placings.
        elves_copy = elves.copy()
        first = max(elves_copy)
        print(f"1st place is elf {elves.index(first) + 1} carrying {first} calories")
        elves_copy.remove(max(elves_copy))
        second = max(elves_copy)
        print(f"2nd place is elf {elves.index(second) + 1} carrying {second} calories")
        elves_copy.remove(max(elves_copy))
        third = max(elves_copy)
        print(f"3rd place is elf {elves.index(third) + 1} carrying {third} calories")
        print(f"together they are carrying {first + second + third}")
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
