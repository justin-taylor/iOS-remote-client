//
//  ViewController.m
//  remote-desktop-client
//
//  Created by Justin Taylor on 3/23/13.
//  Copyright (c) 2013 Tayloredapps. All rights reserved.
//

#import "ViewController.h"
#import "SocketHandler.h"
#import "SettingsView.h"


//Private methods
@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  _touchIsDown = false;
  _messenger = [Messenger new];
  
  //setup the setting view
  _settingsView = [[SettingsView alloc] init];
  [_settingsView setDelegate:self];
  if([SettingsView hasSavedSettings])
  {
    [_settingsView loadSettingsFromUserDefaults];
    [_settingsView setFrame:CGRectMake(-320, 0, 370, 550)];
    [self settingsViewReceivedConnectAction:_settingsView];
  }
  else
  {
    [_settingsView setFrame:CGRectMake(0, 0, 370, 550)];
  }
  
  int width = 100;
  //TODO do a better job of determining locaiton based on orientation
  // also handle orientation changes
  int x = self.view.frame.size.height - width;
  CGRect frame = CGRectMake(x, 0, width, 50);
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setFrame:frame];
  [button addTarget:self
             action:@selector(keyboardAction:)
   forControlEvents:UIControlEventTouchUpInside];
  [button setTitle:NSLocalizedString(@"keyboard_button", NULL)
          forState:UIControlStateNormal];
  
  [self.view addSubview:button];
  [self.view addSubview:_settingsView];
  
  //create a text view to receive the keyboard strokes
  _keyboardField = [UITextField new];
  [_keyboardField setFrame:CGRectMake(-100, -100, 10, 10)];
  [_keyboardField setDelegate:self];
  
  [self.view addSubview:_keyboardField];
  [self.view setBackgroundColor:[UIColor blackColor]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




/*----------------------------------------------------------------------------*/
#pragma mark -
#pragma mark - Keyboard Actions
/*----------------------------------------------------------------------------*/

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
  if([string length] == 0)
  {
    NSLog(@"deleted a char");
  }
  else
  {
    NSLog(@"GOT SOMETHING %@", string);
    
    [_messenger sendKeyStroke:[string characterAtIndex:0]];
  }

  return true;
}


- (void)keyboardAction:(id)sender
{
  if([_keyboardField isFirstResponder])
  {
    [_keyboardField resignFirstResponder];
  }
  
  else
  {
    [_keyboardField becomeFirstResponder];
  }  
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


/*----------------------------------------------------------------------------*/
#pragma mark -
#pragma mark - SettingsViewDelegate
/*----------------------------------------------------------------------------*/


- (void)settingsViewReceivedConnectAction:(SettingsView *)view
{
  int port = [view.outgoingPortField.text intValue];
  if([_messenger setIpAddress:view.ipAddressField.text port:port])
  {
    [_settingsView setVisible:false];
  }
  
  else
  {
    UIAlertView *alert;
    alert = [[UIAlertView alloc]
             initWithTitle:NSLocalizedString(@"connection_alert_title", NULL)
             message:NSLocalizedString(@"connection_alert_message", NULL)
             delegate:NULL
             cancelButtonTitle:NULL
             otherButtonTitles:NSLocalizedString(@"connection_alert_confirm", NULL), nil];
    [alert show];
  }
  
  [view commitSettingsToUserDefaults];
}



@end