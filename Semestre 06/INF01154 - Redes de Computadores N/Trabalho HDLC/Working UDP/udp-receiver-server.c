/* Creates a datagram server. The port 
   number is passed as an argument. This
   server runs forever */

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define IP 64000
#define MAX_SIZE 1024

void error(char *msg)
{
	perror(msg);
	exit(0);
}

int main(int argc, char *argv[])
{
	int sock, length, fromlen, n;
	struct sockaddr_in server;
	struct sockaddr_in from;
	char buffer[MAX_SIZE];
  
	sock = socket(AF_INET, SOCK_DGRAM, 0);
	if(sock < 0)
		error("Opening socket");
	
	fprintf(stderr, "Server started.\n");
		
	length = sizeof(server);
	bzero(&server, length);
	
	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(IP);
   
	if(bind(sock, (struct sockaddr *)&server, length) < 0) 
		error("binding");
		
	fromlen = sizeof(struct sockaddr_in);
	while(1) {
		bzero(buffer, MAX_SIZE);
		n = recvfrom(sock, buffer, MAX_SIZE, 0, (struct sockaddr *)&from, (socklen_t *)&fromlen);
		
		if(n < 0)
			error("recvfrom");
			
		fprintf(stderr, "Received a datagram: ");
		fprintf(stderr, "%s \n", buffer);
		
		bzero(buffer, MAX_SIZE);
		n = sendto(sock, "OK!\n", 4, 0,
					(struct sockaddr *)&from, fromlen);
					
		if(n < 0)
			error("sendto");
   }
   
   return 0;
}
 
 
 
 
 
