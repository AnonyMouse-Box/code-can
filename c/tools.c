#include <tools.h>

int length(list[]){}

int linear_search(list[], int item)
{
    int len = length(list);
    for (int i = 0; i < len; i++)
    {
        if (list[i] == item)
        {
            return i;
        }
    }
    return NULL;
}

int binary_search(list[], int item)
{
    int len = length(list);
    if (len < 2)
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
    int centre = (len / 2) - 1;
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
    index = binary_search(sublist);
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

void selection_sort(list[]){}

void insertion_sort(list[]){}

void bubble_sort(list[]){}

void merge_sort(list[]){}

void quick_sort(list[]){}

void heap_sort(list[]){}