//
//  SocketHandler.m
//  remote-desktop-client
//
//  Created by Justin Taylor on 3/23/13.
//  Copyright (c) 2013 Tayloredapps. All rights reserved.
//

#import "SocketHandler.h"


@implementation SocketHandler



- (id)initWithIpAddress:(NSString *)address
                andPort:(int)port
{
  self = [super init];
  if(self)
  {
    _ipAddress = [address UTF8String];
    _port = port;
  }
  
  return self;
}



/*----------------------------------------------------------------------------*/
#pragma mark -
#pragma mark - Socket communication
/*----------------------------------------------------------------------------*/

- (int)close
{
  return shutdown(_sock, 2);
}



- (BOOL)open
{
  if ((_sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
  {
    printf("Failed to create socket\n");
    return false;
  }
  
  /* Construct the server sockaddr_in structure */
  memset(&_destination, 0, sizeof(_destination));
  
  /* Clear struct */
  _destination.sin_family = AF_INET;
  
  /* Internet/IP */
  _destination.sin_addr.s_addr = inet_addr(_ipAddress);
  
  /* IP address */
  _destination.sin_port = htons(_port);
  
  /* server port */
  setsockopt(_sock,
             IPPROTO_IP,
             IP_MULTICAST_IF,
             &_destination,
             sizeof(_destination));
  
  
  int broadcast = 1;
  // if that doesn't work, try this
  //char broadcast = '1';
  
  // this call is what allows broadcast packets to be sent:
  if (setsockopt(_sock,
                 SOL_SOCKET,
                 SO_BROADCAST,
                 &broadcast,
                 sizeof broadcast) == -1)
  {
    perror("setsockopt (SO_BROADCAST)");
    return false;
  }
  
  
  return true;
}




- (BOOL)send:(NSString *)message
{
  const char *cmsg = [message UTF8String];
  unsigned int echolen = strlen(cmsg);

  int sent = sendto(_sock,
             cmsg,
             echolen,
             0,
             (struct sockaddr *) &_destination,
                    sizeof(_destination));
    
  if(sent != echolen)
  {
    printf("Mismatch in number of sent bytes\n");
    return false;
  }
  else
  {
    NSLog(@"-> Tx: %@",message);
    return true;
  }
}

/*-
 */

+ (int)testReceive:(NSString *)addr
                   :(int)port
                   :(void *)output
{
  int sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
  struct sockaddr_in sa;
  //char buffer[1024];
  
  unsigned int fromlen;
  int recsize;
  
  memset(&sa, 0, sizeof(sa));
  sa.sin_family = AF_INET;
  sa.sin_addr.s_addr = INADDR_ANY;
  sa.sin_port = htons(port);
  
  // bind the socket to our address
  if (-1 == bind(sock,(struct sockaddr *)&sa, sizeof(struct sockaddr)))
  {
    perror("bind failed");
    close(sock);
    exit(EXIT_FAILURE);
  }
  
    recsize = recvfrom(sock,
                       (void *)output,
                       1024,
                       0,
                       (struct sockaddr *)&sa,
                       &fromlen);
  
    if (recsize < 0)
      fprintf(stderr, "%s\n", strerror(errno));
  
  return recsize;
}






@end