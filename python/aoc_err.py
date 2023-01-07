#!/usr/bin/env python3
# aoc_err.py
"""The error handling section of the program. Exit codes given in hexadecimal with a message displying the specific cause of the error."""

import sys
import aoc_main

def throw(error: BaseException, code: str, message: str):
    """
    Generic error throwing function for use within the program

    :param error: The type of error to be thrown.
    :param code: The error code to be provided upon exit.
    :param message: The message to be presented to the user.
    """
    try:
        raise error from None
    except error as e:
        print(f"{type(e).__name__} ({code}) {message}")
        sys.exit(int(code, 16))

def main(argv: list[str]):
    # Handle arguments and throw and error if there are too many or not enough.
    try:
        assert len(argv) == 2
    except AssertionError:
        if len(argv) > 2:
            throw(SyntaxError, "0x03", "Undefined argument.")
        else:
            throw(SyntaxError, "0x04", "Please provide an argument.")

    # Run the main program and listen for keyboard interrupts.
    return_code = None
    try:
        return_code = aoc_main.main(argv)
    except KeyboardInterrupt:
        throw(KeyboardInterrupt, "0x05", "Program exited by user.")

    # Handle the main program return codes.
    match return_code:
        case 0:
            print("(0x00) Program completed successfully.")
        case None:
            throw(RuntimeError, "0x07", "Critical program failure.")
        case _:
            throw(RuntimeError, "0x06", "Unknown error occured.")
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
