#!/usr/bin/env python3
# aoc_day7.py

# Create a dictionary to store the branches of the tree.
tree = {}

def calculate_size(key) -> int:
    """
    Recursively calculate the size of a file or directory.

    :param key: The initial key stored in the tree to calculate.
    :return: The size value of that file or folder.
    :rtype: int
    """
    output = None
    value = tree[key]
    if isinstance(value, int):
        output = value
    elif isinstance(value, list) and len(value) == 0:
        output = 0
    else:
        output = 0
        for item in value:
            if key == '/':
                output += calculate_size(key + item)
            else:
                output += calculate_size(key + '/' + item)
    return output

def main() -> int:
    # Open the file and begin parsing line by line.
    with open('day7_input') as f:
        line = f.readline()
        workdir = "."
        while line != "":
            if line != "\n":
                character = line[0]

                # Detect commands.
                if character == '$':
                    command = line[2:4]

                    # Change directory.
                    if command == "cd":
                        directory = line.strip()[5:]
                        if directory == '/':
                            workdir = '/'
                        elif directory == "..":
                            for i in range(-1, -1 * (len(workdir) + 1), -1):
                                if workdir[i] == '/':
                                    workdir = "/" if workdir[:i] == "" else workdir[:i]
                                    break
                        elif workdir == '/':
                            workdir = '/' + directory
                        else:
                            workdir += '/' + directory
                        if workdir not in tree:
                            tree[workdir] = []

                # Detect directories.
                elif character == 'd':
                    directory = line.strip()[4:]
                    if workdir == '/':
                        tree[workdir].append(directory)
                        tree[workdir + directory] = []
                    else:
                        tree[workdir].append(directory)
                        tree[workdir + '/' + directory] = []

                # Detect files and size.
                else:
                    size, document = line.strip().split()
                    size = int(size)
                    if workdir == '/':
                        tree[workdir].append(document)
                        tree[workdir + document] = size
                    else:
                        tree[workdir].append(document)
                        tree[workdir + '/' + document] = size
            line = f.readline()

        # Calcluate sizes and sum any under 100000.
        output = 0
        sizes = []
        for key in tree:
            if isinstance(tree[key], list):
                size = calculate_size(key)
                sizes.append(size)
                if size <= 100000:
                    output += size
        print(f"Total size of directories under 100000: {output}")

        # Calculate the available space and space needed, then find the smallest file that can be deleted to meet quota.
        space_available = 70000000 - calculate_size("/")
        sizes.sort()
        for value in sizes:
            if value >= 30000000 - space_available:
                print(f"Smallest file that can be deleted to meet quota: {value}")
                break
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
