//include libraries
#include <stdio.h>
#include <cs50.h>
#include <math.h>

//functions
void luhn_al(unsigned long n);
bool switch_bool(bool b);
void length_check(unsigned long n);
void visa_check(unsigned long n);
void amex_check(unsigned long n);
void mastercard_check(unsigned long n);

//global variables
int i = 0;
bool odd = true;
bool luhn = false;
bool visa = false;
bool amex = false;
bool mastercard = false;

//main program
int main(void)
{
    unsigned long input = get_long("Number: ");
    luhn_al(input);
    length_check(input);
    if (luhn && (visa || amex || mastercard)) //check flags
    {
        if (visa)
        {
            printf("VISA\n");
        }
        else if (amex)
        {
            printf("AMEX\n");
        }
        else if (mastercard)
        {
            printf("MASTERCARD\n");
        }
    }
    else
    {
        printf("INVALID\n");
    }
}

//perform Luhn's algorithm
void luhn_al(unsigned long n)
{
    int acc = 0;
    do //iterates digits from the right
    {
        int x;
        if (odd) //if odd just add it
        {
            x = n % 10;
        }
        else //if even double it
        {
            x = (2 * (n % 10));
            if (x >= 10)
            {
                x = (floor(x / 10)) + (x % 10); //if double digit split it
            }
        }
        acc += x;
        odd = switch_bool(odd);
        i++;
        n = floor(n / 10);
    }
    while (n > 0);
    if (acc % 10 == 0) //if algorithm succeeds, set the luhn flag
    {
        luhn = switch_bool(luhn);
    }
}

//function that turns boolean flags on and off like a switch
bool switch_bool(bool b)
{
    b = (b) ? false : true ;
    return b;
}

//checks the length and sends for relevant type check(s)
void length_check(unsigned long n)
{
    for (int j = 0; j < i - 2; j++)
    {
        n = floor(n / 10);
    }
    if (i == 13)
    {
        visa_check(n);
    }
    else if (i == 15)
    {
        amex_check(n);
    }
    else if (i == 16)
    {
        mastercard_check(n);
        visa_check(n);
    }
}

//checks if the number has a 4 as its first digit, sets visa flag if so
void visa_check(unsigned long n)
{
    if (floor(n / 10) == 4)
    {
        visa = switch_bool(visa);
    }
}

//checks if the number has a 34 or 37 as its first digits, sets amex flag if so
void amex_check(unsigned long n)
{
    if (n == 34 || n == 37)
    {
        amex = switch_bool(amex);
    }
}

//checks if the number has a 51-55 as its first digits, sets mastercard flag if so
void mastercard_check(unsigned long n)
{
    if (n >= 51 && n <= 55)
    {
        mastercard = switch_bool(mastercard);
    }
}