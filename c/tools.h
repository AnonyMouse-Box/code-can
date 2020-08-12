//I've tested and there is no in function way to calculate the length of an array, just run sizeof before running these functions
//These functions are currently configured for lists of chars, reconfigure i/o as appropriate

#include <stdlib.h>
#include <stdbool.h>

bool linear_search(const char item, const char list[], const int length, int *result);
bool binary_search(const char item, const char list[], const int length, int *result);

bool selection_sort(char list[], const int length);
bool insertion_sort(char list[], const int length);
bool bubble_sort(char list[], const int length);
bool merge_sort(char list[], const int length);
bool quick_sort(char list[], const int length);
bool heap_sort(char list[], const int length);