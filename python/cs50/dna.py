#!/usr/bin/env python3
from sys import argv
from csv import DictReader
from re import findall


def read_database(database):
    with open(database, newline='') as csvfile:  # read the database into memory as a dictionary
        reader = DictReader(csvfile)
        repeats = {}
        for index in range(1, len(reader.fieldnames)):  # pull the STRs from the headers and build a dictionary for each
            repeats[reader.fieldnames[index]] = dict()
        for row in reader:  # insert the items from each row into the relevant dictionary
            for item in repeats:
                repeats[item][row['name']] = row[item]
    return repeats


def read_sequence(sequence):
    with open(sequence) as txtfile:  # read each line in the sequence file into a list of strings
        lines = txtfile.readlines()
        for index in range(len(lines)):  # strip the newlines and whitespace
            lines[index] = lines[index].rstrip()
    return lines


def find_longest(matches):
    longest = ''
    for match in matches:  # compare lengths to find the longest item
        if len(match) > len(longest):
            longest = match
    return longest


def calculate_repeats(root, match):
    repeats = int(len(match) / len(root))  # divide the match by the root STR to find ow many repetitions there are
    return repeats


def identify_sequence(database, sequence):
    people = []
    for key in database.keys():  # for each STR find all repeating matches take the repeats of the longest and locate the people with that value
        expression = "((?:" + key + ")+)"
        matches = findall(expression, string)
        longest = find_longest(matches)
        repeats = str(calculate_repeats(key, longest))
        people.append([key for (key, value) in database[key].items() if value == repeats])
    match = "No match"
    for person in people[0]:  # iterate over the first list looking for each person in turn
        match = person
        for index in range(1, len(people)):  # search through the other lists to see if the person is there
            confirmed = False
            for item in people[index]:  # look for the person if found break and move onto the next list
                if item is match:
                    confirmed = True
                    break
            if confirmed is False:  # if person not found break and move onto the next person
                break
        if confirmed is True:  # if person matches all lists a match has been found break and report it else reset to no match and continue
            break
        else:
            match = "No match"
    return match


if __name__ == "__main__":
    if len(argv) != 3:
        print("Usage: python dna.py data.csv sequence.txt")
    else:
        database = read_database(argv[1])
        sequence = read_sequence(argv[2])
        for string in sequence:  # iterate over each sequence string to identify whose sequence it is
            match = identify_sequence(database, string)
            print(match)