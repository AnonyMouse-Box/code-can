#include "tools.h"

int linear_search(int item, int list[], int length)
{
    for (int i = 0; i < length; i++)
    {
        if (list[i] == item)
        {
            return i;
        }
    }
    return NULL;
}

int binary_search(int item, int list[], int length)
{
    if (length < 2)
    {
        if (list[0] == item)
        {
            return 0;
        }
        else
        {
            return NULL;
        }
    }
    int centre = (length / 2) - 1;
    int sublist[centre + 1];
    bool greater = false;
    if (list[centre] == item)
    {
        return centre;
    }
    else if (list[centre] < item)
    {
        for (int i = 0; i < centre; i++)
        {
            sublist[i] = centre[i];
        }
    }
    else
    {
        greater = true;
        for (int j = centre + 1, int k = 0; j < len; j++, k++)
        {
            sublist[k] = centre[j];
        }
    }
    len = sizeof sublist / sizeof sublist[0];
    index = binary_search(item, sublist, len);
    if (index == NULL)
    {
        return NULL;
    }
    else if (greater == true)
    {
        index += centre + 1;
    }
    return index;
}

void selection_sort(int list[], int length){}

void insertion_sort(int list[], int length){}

void bubble_sort(int list[], int length){}

void merge_sort(int list[], int length){}

void quick_sort(int list[], int length){}

void heap_sort(int list[], int length){}