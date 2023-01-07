#!/usr/bin/env python3
# aoc_day5.py

def main() -> int:
    # Open the file and read line by line.
    with open('day5_input') as f:
        instructions = False
        line = f.readline()
        arrangement = []
        while line != "":
            if line == "\n":
                instructions = True

                # Create deep copies of 2D list.
                arrangement_1 = [x[:] for x in arrangement]
                arrangement_2 = [x[:] for x in arrangement]

            # Read in the layout.
            elif instructions == False:
                if "[" in line:
                    count = 0
                    for index in range(1, len(line), 4):
                        count += 1
                        if len(arrangement) < count:
                            arrangement.append([])
                        crate = line[index]
                        if not crate.isspace():
                            arrangement[count - 1].append(crate)

            # Read in the instructions.
            else:
                instruction = line.strip().split()
                number, remove, add = int(instruction[1]), int(instruction[3]), int(instruction[5])

                # Follow the instructions.
                for i in range(number):
                    crate = arrangement_1[remove - 1].pop(0)
                    arrangement_1[add - 1].insert(0, crate)

                # Follow the 9001 instructions.
                crates = []
                for i in range(number):
                    crates.append(arrangement_2[remove - 1].pop(0))
                arrangement_2[add - 1] = crates + arrangement_2[add - 1]
            line = f.readline()

        # Collect the labels of the topmost crate in each stack.
        output = ["", ""]
        for i in range(len(arrangement)):
            output[0] += arrangement_1[i][0]
            output[1] += arrangement_2[i][0]
        print(f"Cratemover 9000 top crates: {output[0]}")
        print(f"Cratemover 9001 top crates: {output[1]}")
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
