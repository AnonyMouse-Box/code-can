#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>

string cipher(string text, string key);

int main(int argc, string argv[])
{
    if (argc != 2) //check there are exactly 2 args and the second has 26 characters
    {
        printf("Usage: ./substitution key\n");
        return 1;
    }
    else if (strlen(argv[1]) != 26) //check argument is 26 chars long
    {
        printf("Key must contain 26 characters.\n");
        return 1;
    }
    else
    {
        char key[26];
        for (int i = 0; i < strlen(argv[1]); i++) //iterate over chars in 2nd arg
        {
            if (argv[1][i] < 65 || (argv[1][i] > 90 && argv[1][i] < 97) || argv[1][i] > 122)
            {
                printf("Key must only contain letters.\n");
                return 1;
            }
            else
            {
                argv[1][i] = tolower(argv[1][i]);
                for (int j = 0; j < strlen(key); j++) //iterate over chars in test
                {
                    if (argv[1][i] == key[j]) //check if char is duplicate
                    {
                        printf("Key must not contain duplicates.\n");
                        return 1;
                    }
                }
                key[i] = argv[1][i]; //append char to test list
            }
        }
        string plaintext = get_string("plaintext: "); //get input text
        string ciphertext = cipher(plaintext, key); //calculate ciphertext
        printf("ciphertext: %s\n", ciphertext); //print ciphertext
        return 0;
    }
}

string cipher(string text, string key)
{
    string plain = "abcdefghijklmnopqrstuvwxyz";
    for (int i = 0; i < strlen(text); i++) //iterate over text
    {
        bool upper = false;
        if (text[i] >= 65 && text[i] <= 90) //condense to lower
        {
            upper = true;
            text[i] = tolower(text[i]);
        }
        if (text[i] >= 97 && text[i] <= 122) //if lowercase a-z
        {
            int j;
            int high = 26;
            int low = 0;
            bool match = false;
            do //binary search
            {
                j = (high + low) / 2;
                if (text[i] < plain[j]) //char in lower half
                {
                    high = j;
                }
                else if (text[i] > plain[j]) //char in upper half
                {
                    low = j;
                }
                else //char match
                {
                    text[i] = key[j];
                    match = true;
                }
            }
            while (match == false);
            if (upper == true) //change back to  upper
            {
                text[i] = toupper(text[i]);
            }
        }
    }
    return text;
}