#include <stdio.h>
#include <cs50.h>
#include <math.h>

int count(int n, int c);
int get_input(void);

int coins = 0;

int main(void)
{
    int n = get_input();
    n = count(n, 25); //iterates through the coins
    n = count(n, 10);
    n = count(n, 5);
    n = count(n, 1);
    printf("%i\n", coins);
}

int count(int n, int c)
{
    while (n >= c) //loops taking off one coin at a time until no more can be taken
    {
        n -= c;
        coins++;
    }
    return n;
}

int get_input(void)
{
    float input;
    do
    {
        input = get_float("Change owed: "); //loops input util it's greater than 0
    }
    while (input < 0);
    int n = round(input * 100); //changes to cents and removes any extraneous bits of a cent
    return n;
}