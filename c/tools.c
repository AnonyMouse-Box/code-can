#include <stdio.h>
#include <stdbool.h>
#include <math.h>
#include "tools.h"

void swap(int *item_1, int *item_2)
{
    int store = *item_1;
    *item_1 = *item_2;
    *item_2 = store;
}

int linear_search(int item, int list[], int length)
{
    for (int i = 0; i < length; i++)
    {
        if (list[i] == item)
        {
            return i;
        }
    }
    return -1;
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
            return -1;
        }
    }
    int centre = floor(length / 2);
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
            sublist[i] = list[i];
        }
    }
    else
    {
        greater = true;
        for (int j = centre + 1, k = 0; j < length; j++, k++)
        {
            sublist[k] = list[j];
        }
    }
    int len = sizeof sublist / sizeof sublist[0];
    int index = binary_search(item, sublist, len);
    if (index == -1)
    {
        return -1;
    }
    else if (greater == true)
    {
        index += centre + 1;
    }
    return index;
}

void selection_sort(int list[], int length)
{
    if (length < 2)
    {
        return;
    }
    int select = 2147483647, position = 0;
    for (int i = 0; i < length; i++)
    {
        if (list[i] < select)
        {
            select = list[i];
            position = i;
        }
    }
    if (position != 0)
    {
        swap(&list[0], &list[position]);
    }
    int sublist[length - 1];
    for (int j = 1; j < length; j++)
    {
        sublist[j - 1] = list[j];
    }
    int len = sizeof sublist / sizeof sublist[0];
    selection_sort(sublist, len);
    for (int k = 1; k < length; k++)
    {
        list[k] = sublist[k - 1];
    }
    return;
}

void insertion_sort(int list[], int length){}

void bubble_sort(int list[], int length){}

void merge_sort(int list[], int length){}

void quick_sort(int list[], int length){}

void heap_sort(int list[], int length){}