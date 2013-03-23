//
//  ViewController.h
//  remote-desktop-client
//
//  Created by Justin Taylor on 3/23/13.
//  Copyright (c) 2013 Tayloredapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Messenger.h"


#define TAP_TIMEOUT 0.2

@interface ViewController : UIViewController
{
  // this view will contain the settings for configuring the socket ip and port
  // and other settings
  UIView *_settingsView;
  
  NSDate *_timeOfLastTouch;
    
  Messenger *_messenger;
  
  CGPoint _lastMovePoint;
  BOOL _touchIsDown;
}


@end
