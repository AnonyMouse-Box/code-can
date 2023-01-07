#!/usr/bin/env python3
# aoc_run.py

import sys

# Check python version, display error and exit if wrong
try:
    if sys.version_info.major != 3:
        raise RuntimeError("run with wrong Python version")
except RuntimeError as e:
    print("{} (0x01) Program only supports Python 3.".format(type(e).__name__))
    sys.exit(0x01)

import aoc_err

# Run error handler
if __name__ == "__main__":
    aoc_err.main(sys.argv)
