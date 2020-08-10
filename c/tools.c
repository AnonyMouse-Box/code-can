#include "tools.h"

bool linear_search(const unsigned char item, const unsigned char list[], const unsigned int length, unsigned int *result)
{
    int index = 0;
    for (; index < length; index++)
    {
        if (list[index] == item)
        {
            *result = index;
            return true;
        }
    }
    return false;
}

bool binary_search(const unsigned char item, const unsigned char list[], const unsigned int length, unsigned int *result)
{
    int index = 0;
    return index;
}

bool selection_sort(unsigned char list[], const unsigned int length)
{
    bool result = true;
    return result;
}

bool insertion_sort(unsigned char list[], const unsigned int length)
{
    bool result = true;
    return result;
}

bool bubble_sort(unsigned char list[], const unsigned int length)
{
    bool result = true;
    return result;
}

bool merge_sort(unsigned char list[], const unsigned int length)
{
    bool result = true;
    return result;
}

bool quick_sort(unsigned char list[], const unsigned int length)
{
    bool result = true;
    return result;
}

bool heap_sort(unsigned char list[], const unsigned int length)
{
    bool result = true;
    return result;
}