#include <stdio.h>
#include <cs50.h>
#include <math.h>
int count(int n, int c);
int get_input(void);
int acc = 0;
int coins [] = {200, 100, 50, 20, 10, 5, 2, 1};
int output[] = {0, 0, 0, 0, 0, 0, 0, 0};
      
int main(void)                   
{
    int n = get_input();
    for (int i = 0; i < 8; i++)
    {
        n = count(n, coins[i]); //iterates through the coins
        output[i] = acc - output[i - 1];
    }
    printf("£2 = %d\n£1 = %d\n50p = %d\n20p = %d\n10p = %d\n5p = %d\n2p = %d\n1p = %d\ntotal coins = %i\n", output[0], output[1], output[2], output[3], output[4], output[5], output[6], output[7], acc);
}

int count(int n, int c)
                    
{
    while (n >= c) //loops taking off one coin at a time until no more can be taken
    {
        n -= c;
        acc++;
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
