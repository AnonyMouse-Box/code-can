#include <stdio.h>
#include <cs50.h>

int get_input(void);

int main(void)
{
    int n = get_input();
    for (int i = 0; i < n; i++) //row iterator
    {
        for (int j = 0; j <= 2 * n + 1; j++) //column iterator
        {
            if (i + j < n - 1 || j == n || j == n + 1) //overrides with spaces
            {
                printf(" ");
            }
            else if (!(j - i > n + 2)) //print hash everywhere else except once pyramid is completed
            {
                printf("#");
            }
        }
        printf("\n");
    }
}

int get_input(void)
{
    int n;
    do //repeatedly asks for input until a number between 1 and 9 inclusive is given
    {
        n = get_int("Height: ");
    }
    while (n < 1 || n > 8);
    return n;
}