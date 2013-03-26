//
//  Messenger.m
//  remote-desktop-client
//
//  Created by Justin Taylor on 3/23/13.
//  Copyright (c) 2013 Tayloredapps. All rights reserved.
//

#import "Messenger.h"
#import "SocketHandler.h"

@implementation Messenger

- (id)init
{
  self = [super init];
  if(self)
  {
    
  }
  
  return self;
}


- (BOOL)setIpAddress:(NSString *)address port:(int)port
{
  _outgoingSocket = [[SocketHandler alloc] initWithIpAddress:address
                                                     andPort:port];
  return [_outgoingSocket open];
}



- (BOOL)sendToSocket:(NSString *)message
{
  return [_outgoingSocket send:message];
}


/*----------------------------------------------------------------------------*/
#pragma mark -
#pragma mark - Mouse Control Methods
/*----------------------------------------------------------------------------*/


- (BOOL)moveMouse:(int)deltaX
                 :(int)deltaY
{
  NSString *message = [NSString stringWithFormat:@"p%d/%d", deltaX, deltaY];
  return [self sendToSocket:message];
}



- (BOOL)setMouseButton:(MouseButton)button
                      :(BOOL)down
{
  NSString *message;
  if(button == LEFT)
  {
    if(down)
      message = @"a";
    
    else
      message = @"b";
  }
  
  else if(button == RIGHT)
  {
    if(down)
      message = @"c";
    
    else
      message = @"d";
  }
  
  return [self sendToSocket:message];
}


- (BOOL)scroll:(ScrollDirection)direction
{
  NSString *dir;
  switch (direction)
  {
    case UP: dir = @"h"; break;
    default: dir = @"i"; break;
  }
  
 return [self sendToSocket:dir];
}



/*----------------------------------------------------------------------------*/
#pragma mark -
#pragma mark - Keyboard Control Methods
/*----------------------------------------------------------------------------*/

- (BOOL)sendKeyStroke:(char)key
{
  NSString *msg = [NSString stringWithFormat:@"k%c", key];
  return [self sendToSocket:msg];
}


@end
