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
  
  NSLog(@"SENT %d", sent);
  
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




/*----------------------------------------------------------------------------*/
#pragma mark -
#pragma mark - Socket communication
/*----------------------------------------------------------------------------*/



+(bool) send:(NSString*) msg ipAddress:(NSString*) ip port:(int) p
{
  int sock;
  struct sockaddr_in destination;
  unsigned int echolen;
  int broadcast = 1;
  // if that doesn't work, try this
  //char broadcast = '1';
  
  if (msg == nil || ip == nil)
  {
    printf("Message and/or ip address is null\n");
    return false;
  }
  
  /* Create the UDP socket */
  if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
  {
    printf("Failed to create socket\n");      return false;
  }
  
  /* Construct the server sockaddr_in structure */
  memset(&destination, 0, sizeof(destination));
  
  /* Clear struct */
  destination.sin_family = AF_INET;
  
  /* Internet/IP */
  destination.sin_addr.s_addr = inet_addr([ip UTF8String]);
  
  /* IP address */
  destination.sin_port = htons(p);
  
  /* server port */
  setsockopt(sock,
             IPPROTO_IP,
             IP_MULTICAST_IF,
             &destination,
             sizeof(destination));
  const char *cmsg = [msg UTF8String];   echolen = strlen(cmsg);
  
  // this call is what allows broadcast packets to be sent:
  if (setsockopt(sock,
                 SOL_SOCKET,
                 SO_BROADCAST,
                 &broadcast,
                 sizeof broadcast) == -1)
  {
    perror("setsockopt (SO_BROADCAST)");
    exit(1);
  }
  if (sendto(sock,
             cmsg,
             echolen,
             0,
             (struct sockaddr *) &destination,
             sizeof(destination)) != echolen)
  {
    printf("Mismatch in number of sent bytes\n");
    return false;
  }
  else
  {
    NSLog(@"-> Tx: %@",msg);
    return true;
  }
}


@end