#ifndef __JPEG_H__
#define __JPEG_H__

#include <cstdio>
#include <cstdlib>
#include <cstring>


using namespace std;

#include "jpeglib.h"
#include <setjmp.h> //Used for the optional error recovery mechanism

class Jpeg
{
	//-----------------------------------------------------------------------------
	// Atributs
	//-----------------------------------------------------------------------------
	protected:
		int width;				//image width
		int height;				//image height
		int size;				//image size in bytes
		int channels;			//number of channels (RGB = 3 | RGBA = 4)
		char *filename;	//name of the image
		unsigned char *data;	//pointer to bytes of image

	//-----------------------------------------------------------------------------
	// Methods
	//-----------------------------------------------------------------------------
	public:	
		//Constructors
		Jpeg();					//init empty object	
		Jpeg(Jpeg* other);

		//Destructor
		~Jpeg();

		//Setters
		void SetFilename(char *_filename);

		//Getters
		int getWidth(){ return width; }			
		int getHeight(){ return height; }		
		int getSize(){ return size; }			 
		int getChannels(){ return channels; }		 
		void *getImage(){ return data; } 
		
		//Mirroring
		void VerticalMirroring();
		void HorizontalMirroring();

		//Reads jpeg image, return true if sucess or false if failure
		bool ReadJpegFile();

		//Write jpeg image, return true if sucess or false if failure
		bool WriteJpegFile(char *filename, int quality);
		
	protected:       
		//Initializes the jpeg object
		void init(void);
		
		//Clears all information in the jpeg objects attributes
		void release(void);
		
		void imageFlipUp(void);
	};

#endif

