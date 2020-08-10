//I've tested and there is no in function way to calculate the length of an array, just run sizeof before running these functions
//These functions are currently configured for lists of chars, reconfigure i/o as appropriate

#include <stdbool.h>

bool linear_search(const unsigned char item, const unsigned char list[], const unsigned int length, unsigned int *result);
bool binary_search(const unsigned char item, const unsigned char list[], const unsigned int length, unsigned int *result);

bool selection_sort(unsigned char list[], const unsigned int length);
bool insertion_sort(unsigned char list[], const unsigned int length);
bool bubble_sort(unsigned char list[], const unsigned int length);
bool merge_sort(unsigned char list[], const unsigned int length);
bool quick_sort(unsigned char list[], const unsigned int length);
bool heap_sort(unsigned char list[], const unsigned int length);