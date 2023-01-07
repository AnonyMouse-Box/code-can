#!/usr/bin/env python3
# aoc_day8.py

def count_trees(direction: list[int], height: int) -> int:
    """
    Count how many trees can be seen in a direction.

    :param direction: a list of the heights of trees moving away.
    :param height: the height of the current tree.
    :return: the number of trees that can be seen.
    :rtype: int
    """
    trees = 0
    for i in direction:
        trees += 1
        if i >= height:
            break
    return trees

def main() -> int:
    # Open input file and loop over lines until end.
    with open('day8_input') as f:
        xgrid = []
        line = f.readline()
        while line != "":

            # Construct the grid from input.
            if line != "\n":
                xgrid.append(line.strip())
            line = f.readline()

        # Create grid in the opposing direction.
        ygrid = [''.join([y[x] for y in xgrid]) for x in range(len(xgrid[0]))]
        count = 0
        scenic_score = []

        # Iterate over the entire grid.
        for y in range(len(xgrid)):
            for x in range(len(xgrid[y])):

                # Calculate which trees are visible.
                tree, left, right, up, down = int(xgrid[y][x]), [int(i) for i in xgrid[y][:x]], [int(i) for i in xgrid[y][x+1:]], [int(i) for i in ygrid[x][:y]], [int(i) for i in ygrid[x][y+1:]]
                if not left or not right or not up or not down or max(left) < tree or max(right) < tree or max(up) < tree or max(down) < tree:
                    count += 1

                # Calculate scenic score.
                left.reverse()
                up.reverse()
                scenic_score.append(count_trees(left, tree) * count_trees(right, tree) * count_trees(up, tree) * count_trees(down, tree))

        # Display output.
        print(f"Visible trees: {count}")
        print(f"Max scenic score: {max(scenic_score)}")
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
