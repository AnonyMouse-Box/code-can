#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define MAX_CHAR 100 //set character limit

bool quit = false; //trigger to quit program

void if_char_null(char *ptr);
void if_int_null(int *ptr);
void if_bool_null(bool *ptr);
char* take_input(void);
void process(char* value);

int main(int argc, char *argv[])
{
    char *text = malloc(sizeof (char) * (MAX_CHAR + 2)); //set aside memory for string input
    if_char_null(text);
    if(argc > 1)
    {
        for (int i=1; i < argc; i++) //iterate over arguments
        {
            if (strlen(argv[i]) > MAX_CHAR) //validate arguments
            {
                printf("Too many characters!\n");
                exit(1);
            }
            text = argv[i];
            process(text); //send arguments for processing
        }
    }
    do
    {
        text = take_input(); //gets user input
        if (text[0] == 'q') //detects quit sequence either blank, 'q' or "quit"
        {
            quit = true;
        }
        else
        {
            process(text); //sends user string for processing
        }
    }
    while(quit == false); //request input until quit sequence is given
    free(text);
    return 0;
}

void if_char_null(char *ptr) //null pointer checker for char
{
    if (!ptr)
    {
       exit(1);
    }
    return;
}

void if_int_null(int *ptr) //null pointer checker for int
{
    if (!ptr)
    {
       exit(1);
    }
    return;
}

void if_bool_null(bool *ptr) //null pointer checker for bool
{
    if (!ptr)
    {
       exit(1);
    }
    return;
}

char* take_input(void) //get user input
{
    char *str = malloc(sizeof (char) * (MAX_CHAR + 2)); //set aside some memory for string
    if_char_null(str);
    bool *overflow = malloc(sizeof (bool)); //set aside an overflow bool
    if_bool_null(overflow);
    do
    {
        *overflow = false; //bool reset
        printf("Enter a value: ");
        fgets(str, MAX_CHAR + 2, stdin); //reads input
        if (str[strlen(str) - 1] != 10) //detects lack of a newline
        {
            printf("Too many characters!\n");
            *overflow = true; //triggers a loop
            scanf ("%*[^\n]"); //clears the excess
            getchar(); //clears the newline
        }
    }
    while (*overflow == true); //loops until input is valid
    if (str[0] == 10) //if no input trigger quit sequence
    {
        str[0] = 'q';
    }
    else //replace newline with null character
    {
        str[strlen(str) - 1] = '\0';
    }
    return str;
}

void process(char* text) //build program here to accept strings
{
    printf("%s\n", text);
}