//I've tested and there is no in function way to calculate the length of an array, just run sizeof before running these functions
//These functions are currently configured for lists of ints, reconfigure i/o as appropriate
int linear_search(int item, int list[], int length);
int binary_search(int item, int list[], int length);
void selection_sort(int list[], int length);
void insertion_sort(int list[], int length);
void bubble_sort(int list[], int length);
void merge_sort(int list[], int length);
void quick_sort(int list[], int length);
void heap_sort(int list[], int length);