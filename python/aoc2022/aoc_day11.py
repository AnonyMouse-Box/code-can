#!/usr/bin/env python3
# aoc_day1.py

import copy

class Monkey:
    """Class for tracking monkeys playing with items and passing them around."""

    def __init__(self, name: str, items: list[int], operation: tuple[str], test: tuple[int]):
        """
        Initialize object with given fields.

        :param name: The name associated with this monkey
        :param items: The list of item worry levels this monkey starts with
        :param operation: A tuple containing the operand and number or variable this monkey applies to worry level
        :param test: A tuple containing the divisor for comparison and number of monkeys for true and false conditions
        """
        self.name = name
        self.starting_items = tuple(items)
        self.items = items
        self.operation = operation
        self.test = test
        self.activity = 0
        self.worry = 3
        self.mod = None

    def __repr__(self):
        """Representation of the object for debugging."""
        return f"\nItems: {self.items} Operation: {self.operation} Test: {self.test}\n"

    def __str__(self):
        """Display object as a string for friendly printing"""
        return f"Monkey {self.name}:\n  Starting items: {', '.join([str(s) for s in self.starting_items])}\n  Operation: new = old {' '.join([s for s in self.operation])}\n  Test: divisible by {self.test[0]}\n    If true: throw to monkey {self.test[1]}\n    If false: throw to monkey {self.test[2]}\n"

    def add_item(self, item):
        self.items.append(item)
        return

    def get_item(self):
        return self.items.pop(0)

    def multiply_worry(self, item):
        if self.operation[1] == "old":
            x = item
        else:
            x = int(self.operation[1])
        match self.operation[0]:
            case "+":
                item += x
            case "*":
                item *= x
        return item

    def reduce_worry(self, item):
        return (item // self.worry) % self.mod

    def test_item(self, item):
        return self.test[1] if item % self.test[0] == 0 else self.test[2]

    def inspect(self):
        self.activity += 1
        item = self.reduce_worry(self.multiply_worry(self.get_item()))
        return item, self.test_item(item)

    def set_worry(self, worry):
        self.worry = worry

    def set_mod(self, mod):
        self.mod = mod

def round(monkeys):
    for i in range(len(monkeys)):
        while len(monkeys[i].items) > 0:
            item, number = monkeys[i].inspect()
            monkeys[number].add_item(item)

def calculate_monkey_business(monkeys):
        activity = []
        for monkey in monkeys:
            activity.append(monkey.activity)
        first = max(activity)
        activity.remove(first)
        second = max(activity)
        print(f"Monkey business: {first * second}")
        return

def main() -> int:
    # Open input file and loop over lines until end.
    with open('day11_input') as f:
        line = f.readline()
        monkeys = []
        number, items, operation, test, true, false = None, None, None, None, None, None
        mod = 1
        while line != "":

            # Pull data and build object.
            if line == "\n" and number is not None:
                monkeys.append(Monkey(number, items, operation, (test, true, false)))
            else:
                data = line.strip()
                match data[:4]:
                    case "Monk":
                        number = data[7:-1]
                    case "Star":
                        items = [int(i) for i in data[15:].split(", ")]
                    case "Oper":
                        operation = tuple([i for i in data[21:].split(" ")])
                    case "Test":
                        test = int(data[18:])
                        mod *= test
                    case "If t":
                        true = int(data[24:])
                    case "If f":
                        false = int(data[25:])
                    case _:
                        print("Invalid data read.")
            line = f.readline()
    monkeys.append(Monkey(number, items, operation, (test, true, false)))
    for monkey in monkeys:
        monkey.set_mod(mod)
    monkeys_copy = copy.deepcopy(monkeys)
    for i in range(20):
        round(monkeys)
    calculate_monkey_business(monkeys)
    for monkey in monkeys_copy:
        monkey.set_worry(1)
    for i in range(10000):
        round(monkeys_copy)
    calculate_monkey_business(monkeys_copy)
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
