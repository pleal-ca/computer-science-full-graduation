#ifndef UDP_H
#define	UDP_H

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>

#include "hdlc.h"

/* Function prototypes */

/* Runs the client */
void runClient(char *argv[]);

/* Runs the server */
void runServer();

/* Checks the program aunch arguments for the client */
void checkArguments(char * argv[], struct hostent ** hp, char * filename);

/* Opens the file - will be sent to the server */
FILE * openFile(char * filename, char * option);

/* Send HDLC message */
void sendHDLCMessage(HDLC * myHDLC, int sock, struct sockaddr_in destiny, int length);

/* Receive HDLC message */
HDLC * receiveHDLCMessage(int sock, struct sockaddr_in * source, int * length);


#endif /* UDP_H */