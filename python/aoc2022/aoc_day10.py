#!/usr/bin/env python3
# aoc_day10.py

def main() -> int:
    # Open input file and loop over lines until end.
    with open('day10_input') as f:
        line = f.readline().strip()
        cycle, x, y, total, pixel, row = 0, 1, None, 0, 0, ""
        key_cycles = [20, 60, 100, 140, 180, 220]
        screen = []
        n = 40
        while line != "":
            y = x

            # Read command and perform instruction.
            match line[0:4]:
                case "noop":
                    cycle += 1
                case "addx":
                    cycle += 2
                    x += int(line[5:])

            # Check the key cycles and read the signal strength.
            if key_cycles and cycle >= key_cycles[0]:
                total += y * key_cycles[0]
                key_cycles.pop(0)

            # Track the pixel count to cycles.
            while pixel < cycle:
                char = "."

                # Light the pixel if in range of sprite.
                if pixel % n > y - 2 and pixel % n < y + 2:
                    char = "#"
                row += char

                # Reset the row position for screen edge alignment.
                if len(row) >= n:
                    screen.append(row)
                    row = ""
                pixel += 1
            line = f.readline().strip()
        print(f"Sum of signal strengths: {total}")
        for i in screen:
            print(i)
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
