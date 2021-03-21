#include <math.h>
#include <stdbool.h>

#include "helpers.h"

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
                float b = image[i][j].rgbtBlue;
                float g = image[i][j].rgbtGreen;
                float r = image[i][j].rgbtRed;
                int average = round((b + g + r) / 3);
                image[i][j].rgbtBlue = average;
                image[i][j].rgbtGreen = average;
                image[i][j].rgbtRed = average;
        }
    }
    return;
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
                float b = image[i][j].rgbtBlue;
                float g = image[i][j].rgbtGreen;
                float r = image[i][j].rgbtRed;
                int value = round((0.272 * r) + (0.534 * g) + (0.131 * b));
                image[i][j].rgbtBlue = (value > 255 ? 255 : value);
                value = round((0.349 * r) + (0.686 * g) + (0.168 * b));
                image[i][j].rgbtGreen = (value > 255 ? 255 : value);
                value = round((0.393 * r) + (0.769 * g) + (0.189 * b));
                image[i][j].rgbtRed = (value > 255 ? 255 : value);
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < floor(width / 2); j++)
        {
                RGBTRIPLE store = image[i][width - (j + 1)];
                image[i][width - (j + 1)] = image[i][j];
                image[i][j] = store;
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE copy[height][width];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            copy[i][j] = image[i][j];
        }
    }
    for (int k = 0; k < height; k++)
    {
        bool k_edge = (k == 0 || k == height - 1 ? true : false);
        for (int l = 0; l < width; l++)
        {
            bool l_edge = (l == 0 || l == height - 1 ? true : false);
            float grid_red= 0, grid_green = 0, grid_blue = 0;
            int average_red, average_green, average_blue, y, x, u, v;
            if (k_edge == true && l_edge == true) //corners
            {
                for (int m = 0; m < 2; m++)
                {
                    for (int n = 0; n < 2; n++)
                    {
                        y = k + 1;
                        x = l + 1;
                        if (k == height - 1)
                        {
                            y--;
                        }
                        if (l == width - 1)
                        {
                            x--;
                        }
                        grid_red += copy[y - m][x - n].rgbtRed;
                        grid_green += copy[y - m][x - n].rgbtGreen;
                        grid_blue += copy[y - m][x - n].rgbtBlue;
                    }
                }
                average_red = round(grid_red / 4);
                average_green = round(grid_green / 4);
                average_blue = round(grid_blue / 4);
            }
            else if (k_edge == true || l_edge == true) //edges
            {
                for (int m = 0; m < 3; m++)
                {
                    for (int n = 0; n < 2; n++)
                    {
                        y = k + 1;
                        x = l + 1;
                        u = m;
                        v = n;
                        if (k == 0 || k == height - 1)
                        {
                            u = n;
                            v = m;
                        }
                        if (l == width - 1)
                        {
                            x--;
                        }
                        if (k == height - 1)
                        {
                            y--;
                        }
                        grid_red += copy[y - u][x - v].rgbtRed;
                        grid_green += copy[y - u][x - v].rgbtGreen;
                        grid_blue += copy[y - u][x - v].rgbtBlue;
                    }
                }
                average_red = round(grid_red / 6);
                average_green = round(grid_green / 6);
                average_blue = round(grid_blue / 6);
            }
            else //standard pixels
            {
                for (int m = 0; m < 3; m++)
                {
                    for (int n = 0; n < 3; n++)
                    {
                        grid_red += copy[1 + k - m][1 + l - n].rgbtRed;
                        grid_green += copy[1 + k - m][1 + l - n].rgbtGreen;
                        grid_blue += copy[1 + k - m][1 + l - n].rgbtBlue;
                    }
                }
                average_red = round(grid_red / 9);
                average_green = round(grid_green / 9);
                average_blue = round(grid_blue / 9);
            }
            image[k][l].rgbtRed = average_red;
            image[k][l].rgbtGreen = average_green;
            image[k][l].rgbtBlue = average_blue;
        }
    }
    return;
}
