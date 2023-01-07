#!/usr/bin/env python3
# aoc_day9.py

grid_1 = ['0' * 322 for i in range(363)]
grid_2 = ['0' * 322 for i in range(363)]

def step(knot: list[int], x: bool, positive: bool) -> list[int]:
    """
    Take one step in the specified direction.

    :param knot: the knot coordinates
    :param x: whether horizontal or vertical
    :param positive: whether forward or backward
    :return: the rope coordinates once incremented
    :rtype: list[int]
    """
    if x is True and positive is True:
        knot[0] += 1
    elif x is True and positive is False:
        knot[0] -= 1
    elif x is False and positive is True:
        knot[1] += 1
    else:
        knot[1] -= 1
    return knot

def follow(h: list[int], t: list[int]) -> list[int]:
    """
    Calculate how the tail follows the head of the rope.

    :param h: the head coordinates
    :param t: the tail coordinates
    :return: the updated tail coordinates
    :rtype: list[int]
    """
    touch_x = range(t[0]-1, t[0]+2)
    touch_y = range(t[1]-1, t[1]+2)
    if h[0] == t[0] and h[1] not in touch_y:
        positive = True if h[1] > t[1] else False
        t = step(t, False, positive)
    elif h[1] == t[1] and h[0] not in touch_x:
        positive = True if h[0] > t[0] else False
        t = step(t, True, positive)
    elif h[0] not in touch_x or h[1] not in touch_y:
        positive = True if h[0] > t[0] else False
        t = step(t, True, positive)
        positive = True if h[1] > t[1] else False
        t = step(t, False, positive)
    return t

def mark(knot: list[int], grid: int):
    """
    Mark the current position of the tail.

    :param knot: the knot coordinates
    :param grid: the grid number to use
    """
    if grid == 2:
        grid_2[knot[1]] = grid_2[knot[1]][:knot[0]] + '1' + grid_2[knot[1]][knot[0] + 1:]
    else:
        grid_1[knot[1]] = grid_1[knot[1]][:knot[0]] + '1' + grid_1[knot[1]][knot[0] + 1:]
    return

def move_head(h: list[int], direction: str) -> list[int]:
    """
    Calculate the movement of head and tail of the rope.

    :param h: the head coordinates
    :param direction: the direction of travel
    :return: the head coordinates after movement
    :rtype: list[int]
    """
    match direction:
        case "R":
            x, positive = True, True
        case "L":
            x, positive = True, False
        case "U":
            x, positive = False, True
        case "D":
            x, positive = False, False
    h = step(h, x, positive)
    return h

def count_positions(grid: int) -> int:
    """
    Count the number of positions marked as visited by the tail in the grid.

    :param grid: the number of the grid to use
    :return: the number of positions marked
    :rtype: int
    """
    acc = 0
    if grid == 2:
        [[acc := acc + 1 for x in grid_2[y] if x == '1'] for y in range(len(grid_2))]
    else:
        [[acc := acc + 1 for x in grid_1[y] if x == '1'] for y in range(len(grid_1))]
    return acc

def main() -> int:
    # Open input file and loop over lines until end, set starting coordinates.
    with open('day9_input') as f:
        line = f.readline()
        START = (17, 143)
        rope = [list(START) for i in range(11)]
        mark(rope[1], 1)
        mark(rope[9], 2)
        while line != "":

            # Pull instructions and move rope.
            if line != "\n":
                direction, steps = line.strip().split()
                for i in range(int(steps)):
                    rope[0] = move_head(rope[0], direction)
                    for j in range(1, len(rope)):
                        rope[j] = follow(rope[j - 1], rope[j])
                    mark(rope[1], 1)
                    mark(rope[9], 2)
            line = f.readline()

    # Count up locations in the grids
    count_1 = count_positions(1)
    count_2 = count_positions(2)
    print(f"Number of positions (part 1): {count_1}")
    print(f"Number of positions (part 2): {count_2}")
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
