#include "crc16.h"


/*
Description: 
	Calculate a new fcs given the current fcs, the address, the control, 
	the new data and the fcs in the hdlc message.
Parameters:
	@ u16 fcs : the current fcs.
	@ char address : the address in the hdlc message.
	@ char control : the control byte in the hdlc message.
	@ int datasize : the datasize of the data vector. 
	@ char * data : the vector with data.
	@ char * myfcs : the fcs in the message.
Return:
	A FCS considering all the arguments.
*/
u16 pppfcs16(u16 fcs, char address, char control, int datasize, char * data, char * myfcs) {

	assert(sizeof (u16) == 2);
   	assert(((u16) -1) > 0);
	   
	/* Address */	
	fcs	= (fcs >> 8) ^ fcstab[(fcs ^ address) & 0xff];

	/* Control */
	fcs	= (fcs >> 8) ^ fcstab[(fcs ^ control) & 0xff];

	/* Data */
	while(datasize--)
       fcs = (fcs >> 8) ^ fcstab[(fcs ^ *data++) & 0xff];

	/* FCS */
	if(myfcs != NULL) {
		fcs = (fcs >> 8) ^ fcstab[(fcs ^ *myfcs++) & 0xff];		
		fcs = (fcs >> 8) ^ fcstab[(fcs ^ *myfcs++) & 0xff];
	}
			
	return fcs;
}


/*
Description: 
	Calculates a FCS considering all of the arguments and puts the FCS in an 
	char array.
Parameters:
	@ char address : the address in the hdlc message.
	@ char control : the control byte in the hdlc message.
	@ int datasize : the datasize of the data vector. 
	@ char * data : the vector with data.	
Return:
	The FCS in a char array of size 2.
*/
char * calcFCS(char address, char control, int datasize, char * data) {

	u16 trialfcs;
	char * finalfcs;

	finalfcs = malloc(2 * sizeof(char));

	trialfcs = pppfcs16(PPPINITFCS16, address, control, datasize, data, NULL);
	trialfcs = trialfcs ^ 0xffff; /* complement */
	
	finalfcs[0] = (char)(trialfcs & 0x00ff); /* LSB first  */
	finalfcs[1] = (char)((trialfcs >> 8) & 0x00ff);

	return finalfcs;
}


/*
Description: 
	Check if the FCS has any error.
Parameters:
	@ char address : the address in the hdlc message.
	@ char control : the control byte in the hdlc message.
	@ int datasize : the datasize of the data vector. 
	@ char * data : the vector with data.
	@ char * myfcs : the fcs in the message.	
Return:
	Returns 0 if there is an error or 1 if not.
*/
int checkFCS(char address, char control, int datasize, char * data, char * fcs) {

	u16 trialfcs;
	
	trialfcs = pppfcs16(PPPINITFCS16, address, control, datasize, data, fcs);
   	if(trialfcs == PPPGOODFCS16) {
		fprintf(stderr, "Good FCS\n");	
		return 1;
	}
	else {
		fprintf(stderr, "Bad FCS\n"); 
		return 0;
	}
}










