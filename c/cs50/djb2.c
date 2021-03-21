#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <limits.h>

#define LENGTH 45

#undef get16bits
#if (defined(__GNUC__) && defined(__i386__)) || defined(__WATCOMC__) \
  || defined(_MSC_VER) || defined (__BORLANDC__) || defined (__TURBOC__)
#define get16bits(d) (*((const uint16_t *) (d)))
#endif

#if !defined (get16bits)
#define get16bits(d) ((((uint32_t)(((const uint8_t *)(d))[1])) << 8)\
                       +(uint32_t)(((const uint8_t *)(d))[0]) )
#endif

unsigned long hash(unsigned char *str);
void convert(unsigned int value, unsigned char *str, unsigned int *count);
uint32_t SuperFastHash (const char * data, int len);

int main(int argc, char *argv[])
{
    for(int j = 1; j < argc; j++)
    {
        FILE *dictionary = fopen(argv[j], "r");
        if (dictionary == NULL) return 1;
        char *name = malloc(sizeof (char) * 16);
        if (name == NULL) return 1;
        sprintf(name, "output-%03i.txt", j);
        FILE *output = fopen(name, "a");
        if (output == NULL) return 1;
        free(name);
        char *word = malloc(sizeof (char) * LENGTH);
        if (word == NULL) return 1;
        while (fgets(word, LENGTH + 1, dictionary) != NULL)
        {
            int len = strlen(word);
            unsigned long value = SuperFastHash(word, len);
            unsigned int condensed = value % 180000;
            unsigned char *base64 = malloc(sizeof (int) * 20);
            if (base64 == NULL) return 1;
            unsigned int *count = malloc(sizeof (int));
            if (count == NULL) return 1;
            *count = 0;
            convert(condensed, base64, count);
            for (int i = 0; i < *count; i++)
            {
                char *text = malloc(sizeof (char) * 4);
                if (text == NULL) return 1;
                sprintf(text, "%i ", base64[i]);
                fputs(text, output);
            }
            fputs("\n", output);
            free(count);
            free(base64);
        }
        fclose(dictionary);
        fclose(output);
        free(word);
    }
    return 0;
}

//djb2 hash algorithm built by Dan Bernstein at http://www.cse.yorku.ca/~oz/hash.html
unsigned long hash(unsigned char *str)
{
    unsigned long hash = 5381;
    int c;
    while ((c = *str++))
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
    return hash;
}

//SuperFastHash algorithm built by Paul Hsieh at http://www.azillionmonkeys.com/qed/hash.html
uint32_t SuperFastHash (const char * data, int len)
{
    uint32_t hash = len, tmp;
    int rem;

    if (len <= 0 || data == NULL) return 0;

    rem = len & 3;
    len >>= 2;

    /* Main loop */
    for (;len > 0; len--)
    {
        hash  += get16bits (data);
        tmp    = (get16bits (data+2) << 11) ^ hash;
        hash   = (hash << 16) ^ tmp;
        data  += 2*sizeof (uint16_t);
        hash  += hash >> 11;
    }

    /* Handle end cases */
    switch (rem)
    {
        case 3: hash += get16bits (data);
                hash ^= hash << 16;
                hash ^= ((signed char)data[sizeof (uint16_t)]) << 18;
                hash += hash >> 11;
                break;
        case 2: hash += get16bits (data);
                hash ^= hash << 11;
                hash += hash >> 17;
                break;
        case 1: hash += (signed char)*data;
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

//recursive base64 converter to increase array size but decrease request depth
void convert(unsigned int value, unsigned char *str, unsigned int *count)
{
    unsigned char remain = value % UCHAR_MAX; //split int based on base64 place value system
    unsigned int divisor = floor(value / UCHAR_MAX);
    if (divisor != 0) //catching edge case
    {
        convert(divisor, str, count); //recursive call
    }
    str[*count] = remain; //append base64 value
    *count += 1;
    return;
}