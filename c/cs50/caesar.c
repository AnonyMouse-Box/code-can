#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>

string cipher(string text, int key);

int main(int argc, string argv[])
{
    bool int_flag = true;
    int key = 0;
    if (argc != 2) //check there are exactly 2 args
    {
        int_flag = false;
    }
    else
    {
        for (int i = 0; i < strlen(argv[1]); i++) //iterate over chars in 2nd arg
        {
            if (argv[1][i] < 48 || argv[1][i] > 57) //if not an integer raise flag
            {
                int_flag = false;
            }
            else //build key
            {
                key *= 10;
                key += (argv[1][i] - 48);
            }
        }
    }
    if (int_flag == false) //check flag raise error
    {
        printf("Usage ./caesar key\n");
        return 1;
    }
    else //begin cipher
    {
        key = key % 26; //rationalize key
        string plaintext = get_string("plaintext: "); //get input text
        string ciphertext = cipher(plaintext, key); //calculate ciphertext
        printf("ciphertext: %s\n", ciphertext); //print ciphertext
    }
    return 0;
}

string cipher(string text, int key)
{
    for (int i = 0; i < strlen(text); i++) //iterate over chars
    {
        if ((text[i] >= 65 && text[i] <= 90) || (text[i] >= 97 && text[i] <= 122)) //if a letter run cipher
        {
            if ((tolower(text[i]) + key) > 122) //if out of bounds loop
            {
                text[i] -= 26;
            }
            text[i] = text[i] + key;
        }
    }
    return text;
}