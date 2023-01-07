#!/usr/bin/env python3
# aoc_day6.py

def main() -> int:
    # Open file and read line by line.
    with open('day6_input') as f:
        line = f.readline()
        found = False
        while line != "":
            if line != "\n":

                # Feed in characters one by one up to 14.
                characters = []
                for i in range(14):
                    characters.append("")
                for index in range(len(line.strip())):
                    characters.append(line.strip()[index])
                    characters.pop(0)

                    # Skip ahead until enough characters are filled.
                    if not characters[10] or (not characters[0] and found == True):
                        continue

                    # Generate shorter list to look for start of packet marker.
                    elif found == False:
                        characters_4 = characters[-4:]
                        sublist = characters_4.copy()
                        duplicate = False
                        for character in characters_4:
                            sublist.remove(character)

                            # If duplicate found break the loop and continue progression.
                            if character in sublist:
                                duplicate = True
                                break

                        # If no duplicates output position of marker and lock in found status.
                        if duplicate == False:
                            print(f"Start of packet position: {index + 1}")
                            found = True

                    # Generate a sublist of characters removing one by one.
                    sublist = characters.copy()
                    duplicate = False
                    for character in characters:
                        sublist.remove(character)

                        # If character duplicated break out and progress the stream.
                        if character in sublist:
                            duplicate = True
                            break

                    # If no characters duplicated output position of marker.
                    if duplicate == False:
                        print(f"Start of message position: {index + 1}")
                        break
            line = f.readline()
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
