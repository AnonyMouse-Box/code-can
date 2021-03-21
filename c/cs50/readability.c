#include <stdio.h>
#include <cs50.h>
#include <string.h>

int main(void)
{
    string text = get_string("Text: ");
    float words = 0, letters = 0, sentences = 0;
    bool space = true;
    for (int i = 0; i < strlen(text); i++) //iterate over characters in text
    {
        if (text[i] == ' ')
        {
            space = true; //trigger space flag
        }
        else if (text[i] == '.' || text[i] == '!' || text[i] == '?')
        {
            sentences++; //calculate number of sentences
        }
        else if ((text[i] >= 'a' && text[i] <= 'z') || (text[i] >= 'A' && text[i] <= 'Z'))
        {
            letters++; //calculate number of letters
            if (space == true)
            {
                words++; //calculate number of words
            }
            space = false;
        }
    }
    letters = (letters / words) * 100; //calculate average number of letters per 100 words
    sentences = (sentences / words) * 100; //calculate average number of sentences per 100 words
    float index = 0.0588 * letters - 0.296 * sentences - 15.8; //calculate index
    if (index <= 1) //output (Grade n) where n = int
    {
        printf("Before Grade 1\n");
    }
    else if (index >= 16)
    {
        printf("Grade 16+\n");
    }
    else
    {
        printf("Grade %.0f\n", index);
    }
    return 0;
}
