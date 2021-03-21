// Implements a dictionary's functionality

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <limits.h>
#include <string.h>
#include <ctype.h>

#include "dictionary.h"

#undef get16bits
#if (defined(__GNUC__) && defined(__i386__)) || defined(__WATCOMC__) \
  || defined(_MSC_VER) || defined (__BORLANDC__) || defined (__TURBOC__)
#define get16bits(d) (*((const uint16_t *) (d)))
#endif

#if !defined (get16bits)
#define get16bits(d) ((((uint32_t)(((const uint8_t *)(d))[1])) << 8)\
                       +(uint32_t)(((const uint8_t *)(d))[0]) )
#endif

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 180001;

// Hash table
node *table[N];

node *table[N] = {NULL};
unsigned int words = 0;

uint32_t SuperFastHash(const char *data, int len);
bool lookup(unsigned int hash, const char *value);
bool write(unsigned int hash, const char *value);

// Returns true if word is in dictionary else false
bool check(const char *word)
{
    // TODO
    char *new_word = malloc((LENGTH + 1) * sizeof(char));
    int len = strlen(word);
    for (int i = 0; i < len + 1; i++)
    {
        new_word[i] = tolower(word[i]);
    }
    bool result = lookup(hash(new_word), new_word);
    free(new_word);
    return result;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO
    unsigned int condensed = SuperFastHash(word, strlen(word)) % (180000);
    return condensed;
}

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    // TODO
    FILE *dict = fopen(dictionary, "r");
    bool result;
    char *new_word = malloc((LENGTH + 2) * sizeof(char));
    while (fgets(new_word, LENGTH + 2, dict) != NULL)
    {
        new_word[strlen(new_word) - 1] = '\0';
        result = write(hash(new_word), new_word);
    };
    fclose(dict);
    free(new_word);
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
    for (unsigned int i = 0; i < N; i++)
    {
        if (table[i] == NULL)
        {
            continue;
        }
        else
        {
            free(table[i]);
        }
    }
    return true;
}

//SuperFastHash algorithm built by Paul Hsieh at http://www.azillionmonkeys.com/qed/hash.html
uint32_t SuperFastHash(const char *data, int len)
{
    uint32_t hash = len, tmp;
    int rem;

    if (len <= 0 || data == NULL)
    {
        return 0;
    }

    rem = len & 3;
    len >>= 2;

    /* Main loop */
    for (; len > 0; len--)
    {
        hash  += get16bits(data);
        tmp    = (get16bits(data + 2) << 11) ^ hash;
        hash   = (hash << 16) ^ tmp;
        data  += 2 * sizeof(uint16_t);
        hash  += hash >> 11;
    }

    /* Handle end cases */
    switch (rem)
    {
        case 3:
            hash += get16bits(data);
            hash ^= hash << 16;
            hash ^= ((signed char)data[sizeof(uint16_t)]) << 18;
            hash += hash >> 11;
            break;
        case 2:
            hash += get16bits(data);
            hash ^= hash << 11;
            hash += hash >> 17;
            break;
        case 1:
            hash += (signed char) * data;
            hash ^= hash << 10;
            hash += hash >> 1;
    }

    /* Force "avalanching" of final 127 bits */
    hash ^= hash << 3;
    hash += hash >> 5;
    hash ^= hash << 4;
    hash += hash >> 17;
    hash ^= hash << 25;
    hash += hash >> 6;

    return hash;
}

//performs lookup
bool lookup(unsigned int hash, const char *value)
{
    do
    {
        if (table[hash] == NULL)
        {
            return false;
        }
        else if (strcmp(table[hash] -> word, value) == 0)
        {
            return true;
        }
        hash++;
    }
    while (hash <= N);
    return false;
}

//performs write
bool write(unsigned int hash, const char *value)
{
    do
    {
        if (table[hash] == NULL)
        {
            table[hash] = malloc(sizeof(node));
            strcpy(table[hash] -> word, value);
            words++;
            return true;
        }
        else
        {
            hash++;
        }
    }
    while (hash <= N);
    return false;
}