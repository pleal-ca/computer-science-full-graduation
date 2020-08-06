#ifndef __PI_H
#define __PI_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <GL/glut.h>
#include <GL/glui.h>
#include <opencv/cv.h>
#include <opencv/highgui.h>

// -----------------------------------------------------------------------------
// Image manipulation functions
// -----------------------------------------------------------------------------

/* Load an image */
unsigned char* loadImage(char* filename, IplImage** img);

/* Show an image */
void showImage( IplImage* img );

/* Save an image */
void saveImage();

/* Realods the modified image */
void reloadImage();

/* Makes a series of initializations */
void initPhotonChopp( char *filename );

/* Executes an image horizontal flip */
void horizontalFlip();

/* Executes an image vertical flip */
void verticalFlip();

/* Converts the image to gray scale - Luminancy */
void grayScale();

/* Quantize the number of tones of gray */
void quantizeGray();

/* Quantize the number of tones of RGB */
void quantizeRGB();

/* Converts the image to monochrome (black & white) */
void monochrome();

/* Converts the modified image to its negative */
void negativeMod();

/* Converts the original image to its negative */
void negativeOrg();

/* Applies some brightening on image in the modified image window */
void brightening();

/* Applies contrast ajust on image in the modified image window */
void contrast();

/* Calculates the histogram and normalizes it */
void calcHistogram();

/* Calculates the histogram and normalizes it */
void calcEqualizedHistogram();

// -----------------------------------------------------------------------------
// GUI & GLUT functions
// -----------------------------------------------------------------------------

/* callback function - reshapes window size */
void originalReshape(int width, int height);
void modifiedReshape(int width, int height);

/* callback function - draws image on the window */
void originalDisplay();
void modifiedDisplay();
void histogramDisplay();
void equalizedHistogramDisplay();

/* Sets GLUT's parameters */
void setGlut();

/* Sets GLUI's parameters */
void setGlui();

#endif
