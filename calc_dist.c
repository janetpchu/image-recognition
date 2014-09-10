/*
 * PROJ1-1: YOUR TASK A CODE HERE
 *
 * You MUST implement the calc_min_dist() function in this file.
 *
 * You do not need to implement/use the swap(), flip_horizontal(), transpose(), or rotate_ccw_90()
 * functions, but you may find them useful. Feel free to define additional helper functions.
 */

#include <float.h>
#include <stdlib.h>
#include <stdio.h>
#include "digit_rec.h"
#include "utils.h"
#include <nmmintrin.h>
//#include <emmintrin.h>

float min(float a, float b) {
    if (a < b) {
        return a;
    }
    return b;
}

/* Swaps the values pointed to by the pointers X and Y. */
void swap(float *x, float *y) {
    float temp = *x;
    *x = *y;
    *y = temp;
}

/* Flips the elements of a square array ARR across the y-axis. */
void flip_horizontal(float *arr, int width) {
    int x, y;
    for (y = 0; y < width*width; y += width) {
        for (x = 0; x < width/2; x += 1) {
            swap(&arr[y+x], &arr[width + y - x - 1]);
        }
    }
}

/* Transposes the square array ARR. */
void transpose(float *arr, int width) {
    int size = width * width;
    for (int i = 0; i < size; i += width + 1) { //i is x value
        for (int j = 1; j < (size - i + width - 1)/width; j++) {
            swap(&arr[i + j], &arr[i + j*width]);
        }
    }
}

/* Rotates the square array ARR by 90 degrees counterclockwise. */
void rotate_ccw_90(float *arr, int width) {
    flip_horizontal(arr, width);
    transpose(arr, width);
}

/* Calculates the distance between an IMAGE and a TEMPLATE. */
float calc(float *image, float *template, int i_width, int i_height,
                int t_width, int i, int j) {
    float ret = 0.0;
    float array[4];
    __m128 dist = _mm_setzero_ps();
    
    for (int q = 0; q < t_width; q++) {
        for (int p = 0; p < (t_width/16) * 16; p += 16) { //loop by 16 FLOATS
            __m128 sub = _mm_setzero_ps();
            __m128 _image = _mm_loadu_ps(image + i + p + (q + j) * i_width);
            __m128 _template = _mm_loadu_ps(template + p + q * t_width);

            sub = _mm_sub_ps(_template, _image);
            dist = _mm_add_ps(dist, _mm_mul_ps(sub, sub));

            _image = _mm_loadu_ps(image + i + p + 4 + (q + j) * i_width);
            _template = _mm_loadu_ps(template + p + 4 + q * t_width);

            sub = _mm_sub_ps(_image, _template);
            dist = _mm_add_ps(dist, _mm_mul_ps(sub, sub));

            _image = _mm_loadu_ps(image + i + p + 8 + (q + j) * i_width);
            _template = _mm_loadu_ps(template + p + 8 + q * t_width);

            sub = _mm_sub_ps(_image, _template);
            dist = _mm_add_ps(dist, _mm_mul_ps(sub, sub));

            _image = _mm_loadu_ps(image + i + p + 12 + (q + j) * i_width);
            _template = _mm_loadu_ps(template + p + 12 + q * t_width);

            sub = _mm_sub_ps(_image, _template);
            dist = _mm_add_ps(dist, _mm_mul_ps(sub, sub));
        }


        for (int p = (t_width/16)*16; p < t_width; p++) {
            ret += (image[i + p + (q + j) * i_width] - template[p + q * t_width])
                * (image[i + p + (q + j) * i_width] - template[p + q * t_width]);
        }
    }
    _mm_storeu_ps(array, dist);
    ret += array[0] + array[1] + array[2] + array[3];

    return ret;
}

/* Translates IMAGE across TEMPLATE. */
float translate(float *image, float *template, int i_width, int i_height,
                    int t_width) {
    float min_dist = FLT_MAX;
    for (int j = 0; j <= i_height - t_width; j += 1) {
        for (int i = 0; i <= i_width - t_width; i += 1) {
            min_dist = min(min_dist, calc(image, template, i_width, i_height, t_width, i, j));
        }
    }
    
    return min_dist;
}


/* Returns the squared Euclidean distance between TEMPLATE and IMAGE. The size of IMAGE
 * is I_WIDTH * I_HEIGHT, while TEMPLATE is square with side length T_WIDTH. The template
 * image should be flipped, rotated, and translated across IMAGE.
 */
float calc_min_dist(float *image, int i_width, int i_height,
                           float *template, int t_width) {
    float min_dist = FLT_MAX;
    
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);

    flip_horizontal(template, t_width); //one flip
    
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));

    rotate_ccw_90(template, t_width);
    
    transpose(template, t_width); //transpose
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    
    flip_horizontal(template, t_width); //flipped transpose
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    
    rotate_ccw_90(template, t_width);
    min_dist = min(min_dist, translate(image, template, i_width, i_height, t_width));
    

    return min_dist;
}