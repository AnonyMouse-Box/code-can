#include <math.h>
#include <stdbool.h>

#include "helpers.h"

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    //loop over pixels
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            //transform to float
            float b = image[i][j].rgbtBlue;
            float g = image[i][j].rgbtGreen;
            float r = image[i][j].rgbtRed;
            //calculate average
            int average = round((b + g + r) / 3);
            //reassign to all three
            image[i][j].rgbtBlue = average;
            image[i][j].rgbtGreen = average;
            image[i][j].rgbtRed = average;
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    //loop over pixels
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < floor(width / 2); j++)
        {
            //swap pixel values over
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
    //make a copy of the image
    RGBTRIPLE copy[height][width];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            copy[i][j] = image[i][j];
        }
    }
    //loop over pixels and set edges
    for (int k = 0; k < height; k++)
    {
        bool k_edge = (k == 0 || k == height - 1 ? true : false);
        for (int l = 0; l < width; l++)
        {
            bool l_edge = (l == 0 || l == height - 1 ? true : false);
            float grid_red = 0, grid_green = 0, grid_blue = 0;
            int average_red, average_green, average_blue, y, x, u, v;
            //corners
            if (k_edge == true && l_edge == true)
            {
                //build 2x2 grid
                for (int m = 0; m < 2; m++)
                {
                    for (int n = 0; n < 2; n++)
                    {
                        //set offset variables
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
                        //add to running total
                        grid_red += copy[y - m][x - n].rgbtRed;
                        grid_green += copy[y - m][x - n].rgbtGreen;
                        grid_blue += copy[y - m][x - n].rgbtBlue;
                    }
                }
                //average the grid
                average_red = round(grid_red / 4);
                average_green = round(grid_green / 4);
                average_blue = round(grid_blue / 4);
            }
            //edges
            else if (k_edge == true || l_edge == true)
            {
                //build a 3x2 grid
                for (int m = 0; m < 3; m++)
                {
                    for (int n = 0; n < 2; n++)
                    {
                        //set offset variables
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
                        //add to running total
                        grid_red += copy[y - u][x - v].rgbtRed;
                        grid_green += copy[y - u][x - v].rgbtGreen;
                        grid_blue += copy[y - u][x - v].rgbtBlue;
                    }
                }
                //average the grid
                average_red = round(grid_red / 6);
                average_green = round(grid_green / 6);
                average_blue = round(grid_blue / 6);
            }
            //standard pixels
            else
            {
                //build a 3x3 grid
                for (int m = 0; m < 3; m++)
                {
                    for (int n = 0; n < 3; n++)
                    {
                        //add to running total
                        grid_red += copy[1 + k - m][1 + l - n].rgbtRed;
                        grid_green += copy[1 + k - m][1 + l - n].rgbtGreen;
                        grid_blue += copy[1 + k - m][1 + l - n].rgbtBlue;
                    }
                }
                //average the grid
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

// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    //make a copy of the picture
    RGBTRIPLE copy[height][width];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            copy[i][j] = image[i][j];
        }
    }
    //loop over pixels
    for (int k = 0; k < height; k++)
    {
        for (int l = 0; l < width; l++)
        {
            //set variables
            float grid_red[9], grid_green[9], grid_blue[9];
            float edge_red_x = 0, edge_green_x = 0, edge_blue_x = 0, edge_red_y = 0, edge_green_y = 0, edge_blue_y = 0;
            long average_red, average_green, average_blue;
            int grid_x[] = {-1, 0, 1, -2, 0, 2, -1, 0, 1};
            int grid_y[] = {-1, -2, -1, 0, 0, 0, 1, 2, 1};
            //build a 3x3 grid
            for (int m = 0, z = 0; m < 3; m++)
            {
                for (int n = 0; n < 3; n++, z++)
                {
                    //catch edge spaces
                    if ((1 + k - m) < 0 || (1 + l - n) < 0 || (1 + k - m) > (height - 1) || (1 + l - n) > (width - 1))
                    {
                        grid_red[z] = 0x00;
                        grid_green[z] = 0x00;
                        grid_blue[z] = 0x00;
                    }
                    else
                    {
                        //set up pixel mapping
                        grid_red[z] = copy[1 + k - m][1 + l - n].rgbtRed;
                        grid_green[z] = copy[1 + k - m][1 + l - n].rgbtGreen;
                        grid_blue[z] = copy[1 + k - m][1 + l - n].rgbtBlue;
                    }
                    //collapse the grid with Gx and Gy values
                    edge_red_x += (grid_x[z] * grid_red[z]);
                    edge_green_x += (grid_x[z] * grid_green[z]);
                    edge_blue_x += (grid_x[z] * grid_blue[z]);
                    edge_red_y += (grid_y[z] * grid_red[z]);
                    edge_green_y += (grid_y[z] * grid_green[z]);
                    edge_blue_y += (grid_y[z] * grid_blue[z]);
                }
            }
            //perform square and square root
            average_red = round(sqrt((edge_red_x * edge_red_x) + (edge_red_y * edge_red_y)));
            average_green = round(sqrt((edge_green_x * edge_green_x) + (edge_green_y * edge_green_y)));
            average_blue = round(sqrt((edge_blue_x * edge_blue_x) + (edge_blue_y * edge_blue_y)));
            //cap at 255
            average_red = (average_red > 255 ? 255 : average_red);
            average_green = (average_green > 255 ? 255 : average_green);
            average_blue = (average_blue > 255 ? 255 : average_blue);
            //write back to pixels
            image[k][l].rgbtRed = average_red;
            image[k][l].rgbtGreen = average_green;
            image[k][l].rgbtBlue = average_blue;
        }
    }
    return;
}
