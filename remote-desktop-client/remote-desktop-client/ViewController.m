//
//  ViewController.m
//  remote-desktop-client
//
//  Created by Justin Taylor on 3/23/13.
//  Copyright (c) 2013 Tayloredapps. All rights reserved.
//

#import "ViewController.h"
#import "SocketHandler.h"


//Private methods
@interface ViewController ()

- (void)_layoutViews;

@end




@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self _layoutViews];

  _touchIsDown = false;
  _messenger = [Messenger new];
  [_messenger setIpAddress:@"192.168.1.111"
                      port:5444];
}



/**
 Creates and lays out the views
 */
- (void)_layoutViews
{
  //TODO
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




/*----------------------------------------------------------------------------*/
#pragma mark -
#pragma mark - Touch recognition
/*----------------------------------------------------------------------------*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  _timeOfLastTouch = [NSDate date];
  
  // the number fo touch events
  NSSet *allTouches = [event allTouches];
  
  NSLog(@"TOUCH BEGAN %@ %d", _timeOfLastTouch, [allTouches count]);
  
  
  
  if(!_touchIsDown)
  {
    NSArray *touchesArray = [touches allObjects];
    UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
    CGPoint point = [touch locationInView:[self view]];
    _lastMovePoint = point;
  }
  _touchIsDown = true;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSSet *allTouches = [event allTouches];
  int touchCount = [allTouches count];
  
  NSArray *touchesArray = [touches allObjects];
  UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
  CGPoint point = [touch locationInView:[self view]];

  
  NSLog(@"TOUCH MOVED %d", touchCount);

  if (touchCount == 1)
  {
    int deltaX = point.x - _lastMovePoint.x;
    int deltaY = point.y - _lastMovePoint.y;
    [_messenger moveMouse:deltaX :deltaY];
  }
  
  else
  {
    ScrollDirection direction;
    if(_lastMovePoint.y > point.y)
    {
      direction = DOWN;
    }
    
    else
    {
      direction = UP;
    }
    
    [_messenger scroll:direction];
  }
  
  
  _lastMovePoint = point;
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  _touchIsDown = false;
  
  
  NSSet *allTouches = [event allTouches];

  NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:_timeOfLastTouch];
  NSLog(@"TIME: %f  %d", time, [allTouches count]);
  
  
  if(time < TAP_TIMEOUT)
  {
    MouseButton button;
    if([allTouches count] > 1)
    {
      button = RIGHT;
    }
    
    else
    {
      button = LEFT;
    }
    
    [_messenger setMouseButton:button
                              :true];
    
    [_messenger setMouseButton:button
                              :false];
    NSLog(@"TAP  %d", button);
  }
}




@end