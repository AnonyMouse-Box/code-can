//I've tested and there is no in function way to calculate the length of an array, just run sizeof before running these functions
//These functions are currently configured for lists of chars, reconfigure i/o as appropriate

#include <stdbool.h>

int linear_search(char item, char list[]);
int binary_search(char item, char list[]);

bool selection_sort(char list[], int length);
bool insertion_sort(char list[], int length);
bool bubble_sort(char list[], int length);
bool merge_sort(char list[], int length);
bool quick_sort(char list[], int length);
bool heap_sort(char list[], int length);