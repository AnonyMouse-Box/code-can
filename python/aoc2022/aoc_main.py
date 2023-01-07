#!/usr/bin/env python3
# aoc_main.py

import aoc_day1, aoc_day2, aoc_day3, aoc_day4, aoc_day5, aoc_day6, aoc_day7, aoc_day8, aoc_day9, aoc_day10, aoc_day11

def main(argv: list[str]) -> int:
    """
    Main function for choosing which problem solution to run.

    :param argv: A list of arguments containing the program name and the user choice.
    :return: An exit code signifying the status upon completion.
    :rtype: int
    """
    print("Booting software...")
    try:
        day = int(argv[1])
    except ValueError:
        from aoc_err import throw
        throw(ValueError, "0x08", "Argument should be an integer.")
    match day:
        case 1:
            aoc_day1.main()
        case 2:
            aoc_day2.main()
        case 3:
            aoc_day3.main()
        case 4:
            aoc_day4.main()
        case 5:
            aoc_day5.main()
        case 6:
            aoc_day6.main()
        case 7:
            aoc_day7.main()
        case 8:
            aoc_day8.main()
        case 9:
            aoc_day9.main()
        case 10:
            aoc_day10.main()
        case 11:
            aoc_day11.main()
        case _:
            from aoc_err import throw
            throw(ValueError, "0x09", "Undefined argument.")
    print("Shutting down...")
    return 0

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
