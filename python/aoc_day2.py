#!/usr/bin/env python3
# aoc_day2.py

def main() -> int:
    # Open file and loop over lines.
    with open('day2_input') as f:
        line = f.readline().strip()
        total = [0, 0]
        while line != "":

            # Set table based on opponent choice.
            choice = ["Rock", "Paper", "Scissors"]
            opponent = None
            match line[0]:
                case "A":
                    opponent = "Rock"
                    choice = choice[-1:] + choice[:-1]
                case "B":
                    opponent = "Paper"
                case "C":
                    opponent = "Scissors"
                    choice = choice[1:] + choice[:1]
            opponent_index = choice.index(opponent)

            # Set contender choice.
            contender = []
            match line[2]:
                case "X":
                    contender.append(choice.index("Rock"))
                case "Y":
                    contender.append(choice.index("Paper"))
                case "Z":
                    contender.append(choice.index("Scissors"))

            # Set contender choice based on intent to win.
            match line[2]:
                case "X":
                    contender.append(0)
                case "Y":
                    contender.append(1)
                case "Z":
                    contender.append(2)

            # Loop over values for p1 and p2.
            for i in range(len(contender)):

                # Set base points for choice.
                base_points = None
                match choice[contender[i]]:
                    case "Rock":
                        base_points = 1
                    case "Paper":
                        base_points = 2
                    case "Scissors":
                        base_points = 3

                # Calculate game points
                outcome_points = 0
                if opponent is None or contender[i] is None or base_points is None:
                    break
                elif contender[i] == opponent_index:
                    outcome_points = 3
                elif contender[i] > opponent_index:
                    outcome_points = 6
                total[i] += base_points + outcome_points
            line = f.readline().strip()
        print(f"Part One total points: {total[0]}")
        print(f"Part Two total points: {total[1]}")
    return

# Throw an error if run directly.
try:
    assert __name__ != "__main__"
except AssertionError:
    from aoc_err import throw
    throw(RuntimeError, "0x02", "Please run from aoc_run.py.")
