// Implements a dictionary's functionality

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <ctype.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 700001;

// Hash table
node *table[N];

unsigned int words = 0;

unsigned long djb2(unsigned char *str);
bool lookup(node *ptr, const char *value);
bool write(node *ptr, const char *value);
bool delete_list(node *ptr);

// Returns true if word is in dictionary else false
bool check(const char *word)
{
    // TODO
    char *new_word = calloc(LENGTH + 1, sizeof (char));
    if (new_word == NULL) exit(1);
    for (int i = 0; i < strlen(word); i++)
    {
        new_word[i] = tolower(word[i]);
    }
    unsigned int value = hash(new_word);
    bool result = lookup(table[value], new_word);
    free(new_word);
    return result;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO
    unsigned char *uword = calloc(LENGTH + 1, sizeof (char));
    if (uword == NULL) exit(1);
    for (int i = 0; i < strlen(word); i++)
    {
        uword[i] = word[i];
    }
    unsigned long output = djb2(uword);
    free(uword);
    unsigned int condensed = output % (700000);
    return condensed;
}

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    // TODO
    for (unsigned int i = 0; i < N; i++)
    {
        table[i] = calloc(1, sizeof (node));
        *(table[i] -> word) = '\0';
        table[i] -> next = NULL;
    }
    FILE *dict = fopen(dictionary, "r");
    if (dictionary == NULL) return false;
    char *word = calloc(LENGTH + 2, sizeof (char));
    if (word == NULL) return false;
    bool result;
    while (fgets(word, LENGTH + 2, dict) != NULL)
    {
        word[strlen(word) - 1] = '\0';
        for (int i = 0; i < strlen(word); i++)
        {
            word[i] = tolower(word[i]);
        }
        unsigned int value = hash(word);
        result = write(table[value], word);
        words++;
    }
    fclose(dict);
    free(word);
    return result;
}

// Returns number of words in dictionary if loaded else 0 if not yet loaded
unsigned int size(void)
{
    // TODO
    return words;
}

// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    // TODO
    bool result;
    for (unsigned int i = 0; i < N; i++)
    {
        result = delete_list(table[i]);
    }
    return result;
}

//djb2 hash algorithm built by Dan Bernstein at http://www.cse.yorku.ca/~oz/hash.html
unsigned long djb2(unsigned char *str)
{
    unsigned long hash = 5381;
    int c;
    while ((c = *str++))
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
    return hash;
}

//performs recursive lookup
bool lookup(node *ptr, const char *value)
{
    if (strcmp(ptr -> word, value) == 0)
    {
        return true;
    }
    else
    {
        if (ptr -> next == NULL)
        {
            return false;
        }
        else
        {
            bool result = lookup(ptr -> next, value);
            return result;
        }
    }
}

//performs recursive write
bool write(node *ptr, const char *value)
{
    if (ptr -> word[0] == '\0')
    {
        strcpy(ptr -> word, value);
        return true;
    }
    else
    {
        if (ptr -> next == NULL)
        {
            node *new_node = calloc(1, sizeof (node));
            *(new_node -> word) = '\0';
            new_node -> next = NULL;
            ptr -> next = new_node;
        }
        bool result = write(ptr -> next, value);
        return result;
    }
}

//recursively deletes singly linked list
bool delete_list(node *ptr)
{
    if (ptr -> next != NULL)
    {
        delete_list(ptr -> next);
        ptr -> next = NULL;
    }
    free(ptr);
    words -= 1;
    return true;
}