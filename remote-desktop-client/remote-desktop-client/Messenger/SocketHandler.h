//
//  SocketHandler.h
//  remote-desktop-client
//
//  Created by Justin Taylor on 3/23/13.
//  Copyright (c) 2013 Tayloredapps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

/**
 
 This class handles the raw UDP socket communication with an endpoint.
 
 */
@interface SocketHandler : NSObject
{
  const char *_ipAddress;
  int _port;
  
  int _sock;
  struct sockaddr_in _destination;
}

/**
 
 */
- (id)initWithIpAddress:(NSString *)address
                andPort:(int)port;


- (BOOL)open;
- (int)close;

- (BOOL)send:(NSString *)message;


+ (int)testReceive:(NSString *)addr
                   :(int)port
                   :(void *)output;
@end