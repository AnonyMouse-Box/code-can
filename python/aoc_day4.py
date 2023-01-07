#!/usr/bin/env python3
# aoc_day4.py

def main() -> int:
    # Open the file and read the ranges.
    with open('day4_input') as f:
        contained, overlap = 0, 0
        line = f.readline()
        while line != "":
            if line != "\n":

                # Split the input and read the from and to.
                assignments = []
                for assignment in line.strip().split(","):
                    assignments.append([int(value) for value in assignment.split("-")])

                # Compare the ranges detecting if one contains the other.
                if (assignments[1][0] <= assignments[0][0] <= assignments[1][1] and assignments[1][0] <= assignments[0][1] <= assignments[1][1]) or (assignments[0][0] <= assignments[1][0] <= assignments[0][1] and assignments[0][0] <= assignments[1][1] <= assignments[0][1]):
                    contained += 1

                # Compare the ranges detecting overlap.
                if (assignments[1][0] <= assignments[0][0] <= assignments[1][1] or assignments[1][0] <= assignments[0][1] <= assignments[1][1]) or (assignments[0][0] <= assignments[1][0] <= assignments[0][1] or assignments[0][0] <= assignments[1][1] <= assignments[0][1]):
                    overlap += 1
            line = f.readline()
        print(f"Ranges fully contained: {contained}")
        print(f"Ranges overlapping: {overlap}")
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
