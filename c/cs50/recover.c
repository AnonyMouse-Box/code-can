#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef uint8_t BYTE;

int main(int argc, char *argv[])
{
    if (argc != 2) //check one arg is given
    {
        printf("Usage: ./recover image\n");
        return 1;
    }
    FILE *raw = fopen(argv[1], "rb"); //open raw
    if (raw == NULL)
    {
        printf("Could not open file");
        return 1;
    }
    char name[8];
    int i = 0, size;
    FILE *image = fopen("garbage.raw", "ab"); //open initial garbage file
    do
    {
        BYTE *hex = malloc(sizeof(BYTE) * 512); //set up buffer
        if (hex == NULL)
        {
            return 1;
        }
        size = fread(hex, sizeof(BYTE), 512, raw); //read from raw
        if (hex[0] == 0xff && hex[1] == 0xd8 && hex[2] == 0xff && (hex[3] < 0xf0 && hex[3] > 0xdf)) //check for magic number
        {
            sprintf(name, "%03i.jpg", i);
            FILE *new_image = fopen(name, "ab"); //open image
            if (new_image == NULL)
            {
                return 1;
            }
            fclose(image); //close old image
            image = new_image; //and swap pointer
            i++;
        }
        fwrite(hex, sizeof(BYTE), size, image); //write to image
        free(hex);
    }
    while (!feof(raw)); //loop until end
    fclose(image);
    fclose(raw);
    return 0;
}