//
//  Messenger.h
//  remote-desktop-client
//
//  Created by Justin Taylor on 3/23/13.
//  Copyright (c) 2013 Tayloredapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketHandler.h"


/**
 Used to indicate a direction when sending the scroll command
 */
typedef enum
{
  UP,
  DOWN
} ScrollDirection;

/*
 Used to indicate which mouse button will receive an action
 */
typedef enum
{
  LEFT,
  RIGHT,
  
} MouseButton;


/**
 
 Sends formatted messages to the server
 
 */
@interface Messenger : NSObject
{
  SocketHandler *_outgoingSocket;
}


/**
 Sets the ip and port on the outgoing socket. This will attempt to open the 
 socket.
 
 @return whether the socket opened
 */
- (BOOL)setIpAddress:(NSString *)address port:(int)port;

/**
 Closes the socket connection. The socket cannot be reused until calling
 setIpAddress:port again to reestablish a connection
 */
- (BOOL)close;


/**
 Instructs the server to move the mouse
 
 @param deltaX the number of pixels to move the mouse on the x axis
 @param deltaY the number of pixels to move the mouse on the y axis

 */
- (BOOL)moveMouse:(int)deltaX
                 :(int)deltaY;



/**
 
 Instructs the server to set a mouse button either up or down
 
 @param button which mouse button to set
 @param down if the mouse button should be pressed down

 */
- (BOOL)setMouseButton:(MouseButton)button
                      :(BOOL)down;



/**
 Instructs the server scroll in the specified direction
 
 @param direction
 
 */
- (BOOL)scroll:(ScrollDirection)direction;


/**
 Instructs the server to type a character
 
 @param key the character the be typed
 */
- (BOOL)sendKeyStroke:(char)key;


- (BOOL)requestImage:(int)width
                    :(int)height;
@end
