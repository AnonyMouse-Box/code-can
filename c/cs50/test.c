#include <stdio.h> //used for printf
#include <string.h>

#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

bool linear_search(const char item, const char list[], const int length, int *result);
bool binary_search(const char item, const char list[], const int length, int *result);

bool selection_sort(char list[], const int length);
bool insertion_sort(char list[], const int length);
bool bubble_sort(char list[], const int length);
bool merge_sort(char list[], const int length);
bool quick_sort(char list[], const int length);
bool heap_sort(char list[], const int length);

int main(int argc, char *argv[]) //for testing
{
    char list[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '\0'};
    int *index = calloc(1, sizeof(int));
    if (index == NULL)
    {
        return 1;
    }
    *index = 0;
    bool result = binary_search(argv[1][0], list, strlen(list), index);
    if (result == true)
    {
        printf("%i\n", *index);
    }
    for (int i = 0; i < 26; i++)
    {
        printf("%c", list[i]);
    }
    printf("\n");
    return 0;
}

bool linear_search(const char item, const char list[], const int length, int *index)
{
    for (*index = 0; *index < length; *index += 1)
    {
        if (list[*index] == item)
        {
            return true;
        }
    }
    return false;
}

bool binary_search(const char item, const char list[], const int length, int *index)
{
    *index = floor(length / 2);
    int store = 0;
    int splitter = *index + 1;
    char sublist[splitter];
    if (list[*index] == item)
    {
        return true;
    }
    else if (list[*index] > item)
    {
        int i = 0;
        for (; i < *index; i++)
        {
            sublist[i] = list[i];
        }
        sublist[i] = 0;
    }
    else
    {
        for (int i = splitter; i < length; i++)
        {
            sublist[i - splitter] = list[i];
        }
        store += *index;
    }
    int len = strlen(sublist);
    if (len < 1)
    {
        return false;
    }
    else
    {
        bool result = binary_search(item, sublist, len, index);
        *index += store + 1;
        return result;
    }
}

bool selection_sort(char list[], const int length)
{
    bool result = true;
    return result;
}

bool insertion_sort(char list[], const int length)
{
    bool result = true;
    return result;
}

bool bubble_sort(char list[], const int length)
{
    bool result = true;
    return result;
}

bool merge_sort(char list[], const int length)
{
    bool result = true;
    return result;
}

bool quick_sort(char list[], const int length)
{
    bool result = true;
    return result;
}

bool heap_sort(char list[], const int length)
{
    bool result = true;
    return result;
}