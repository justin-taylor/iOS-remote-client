//
//  SettingsView.m
//  remote-desktop-client
//
//  Created by Justin Taylor on 3/24/13.
//  Copyright (c) 2013 Tayloredapps. All rights reserved.
//

#import "SettingsView.h"

#define SAVED_SETTING_KEY @"SAVED_SETTING_KEY"
#define SENSITIVITY_SETTING_KEY @"SENSITIVITY_SETTING_KEY"
#define IP_ADDRESS_SETTING_KEY @"IP_ADDRESS_SETTING_KEY"
#define OUTGOING_PORT_SETTING_KEY @"OUTGOING_PORT_SETTING_KEY"
#define INCOMING_PORT_SETTING_KEY @"INCOMING_PORT_SETTING_KEY"
#define USE_SCREEN_CAPTURE_SETTING_KEY @"USE_SCREEN_CAPTURE_SETTING_KEY"
#define FRAME_RATE_SETTING_KEY @"FRAME_RATE_SETTING_KEY"

@implementation SettingsView

- (id)init
{
  self = [super init];
  if(self)
  {
    CGRect frame;
    NSString *placeholder;
    int yOffset = 20;
    int padding = 20;
    int textViewHeight = 30;
    
    frame = CGRectMake(320, 0, 50, 50);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:frame];
    [button addTarget:self
               action:@selector(pullOutAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    frame = CGRectMake(padding, yOffset, 280, 23);
    self.sensitivitySlider = [UISlider new];
    [self.sensitivitySlider setFrame:frame];
    
    yOffset += frame.size.height + padding;
    frame = CGRectMake(padding, yOffset, 280, textViewHeight);
    self.ipAddressField = [UITextField new];
    [self.ipAddressField setFrame:frame];
    placeholder = NSLocalizedString(@"ip_address_placeholder", @"ip address");
    [self.ipAddressField setPlaceholder:placeholder];
    [self.ipAddressField setReturnKeyType:UIReturnKeyNext];
    [self.ipAddressField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.ipAddressField setDelegate:self];
    
    yOffset += frame.size.height + padding;
    frame = CGRectMake(padding, yOffset, 280, textViewHeight);
    self.outgoingPortField = [UITextField new];
    [self.outgoingPortField setFrame:frame];
    placeholder = NSLocalizedString(@"out_port_placeholder", @"outgoing port");
    [self.outgoingPortField setPlaceholder:placeholder];
    [self.outgoingPortField setReturnKeyType:UIReturnKeyNext];
    [self.outgoingPortField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.ipAddressField setDelegate:self];
    
    yOffset += frame.size.height + padding;
    frame = CGRectMake(padding, yOffset, 79, 27);
    self.useScreenCatpture = [UISwitch new];
    [self.useScreenCatpture setFrame:frame];
    
    yOffset += frame.size.height + padding;
    frame = CGRectMake(padding, yOffset, 280, textViewHeight);
    self.incomingPortField = [UITextField new];
    [self.incomingPortField setFrame:frame];
    placeholder = NSLocalizedString(@"in_port_placeholder", @"incoming port");
    [self.incomingPortField setPlaceholder:placeholder];
    [self.incomingPortField setReturnKeyType:UIReturnKeyNext];
    [self.incomingPortField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.incomingPortField setDelegate:self];
    
    yOffset += frame.size.height + padding;
    frame = CGRectMake(padding, yOffset, 50, textViewHeight);
    self.frameRateField = [UITextField new];
    [self.frameRateField setFrame:frame];
    placeholder = NSLocalizedString(@"fps_placeholder", @"FPS");
    [self.frameRateField setPlaceholder:placeholder];
    [self.frameRateField setReturnKeyType:UIReturnKeyNext];
    [self.frameRateField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.frameRateField setDelegate:self];
    
    [self addSubview:self.sensitivitySlider];
    [self addSubview:self.ipAddressField];
    [self addSubview:self.outgoingPortField];

    [self addSubview:self.useScreenCatpture];
    [self addSubview:self.incomingPortField];
    [self addSubview:self.frameRateField];
    
    //create the connected button
    yOffset += frame.size.height + padding;
    frame = CGRectMake(padding, yOffset, 280, textViewHeight);
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:frame];
    [button addTarget:self
               action:@selector(connectAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:NSLocalizedString(@"connect_button", @"Connected")
            forState:UIControlStateNormal];
    [self addSubview:button];

  }
  
  return self;
}



/*----------------------------------------------------------------------------*/
#pragma mark -
#pragma mark - UIButton Actions
/*----------------------------------------------------------------------------*/

- (void)setVisible:(BOOL)show
{
  [UIView animateWithDuration:0.3 animations:^
   {
     CGRect frame = self.frame;
     if(show)
     {
       frame.origin.x = 0;
     }
     
     else
     {
       frame.origin.x = -320;
     }
     
     [self setFrame:frame];
   }];
}

- (void)pullOutAction:(id)sender
{
  [self setVisible:self.frame.origin.x != 0];
}


- (void)connectAction:(id)sender
{
  [self.delegate settingsViewReceivedConnectAction:self];
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  BOOL didResign = [textField resignFirstResponder];
  if (!didResign) return NO;
  
  if(textField == self.ipAddressField)
  {
    [self.outgoingPortField becomeFirstResponder];
  }
  
  else if(textField == self.outgoingPortField)
  {
    [self.incomingPortField becomeFirstResponder];
  }
  
  else if(textField == self.incomingPortField)
  {
    [self.frameRateField becomeFirstResponder];
  }
    
  return textField == self.frameRateField;
}



/*----------------------------------------------------------------------------*/
#pragma mark -
#pragma mark - Touch recognition
/*----------------------------------------------------------------------------*/


+ (BOOL)hasSavedSettings
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  return [defaults boolForKey:SAVED_SETTING_KEY];
}

- (void)loadSettingsFromUserDefaults
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  float value = 0.0;
  NSNumber *sensitivity = [defaults objectForKey:SENSITIVITY_SETTING_KEY];
  if(!sensitivity)
  {
    value = [sensitivity floatValue];
  }
  [self.sensitivitySlider setValue:value];
  
  NSString *ipAddress = [defaults objectForKey:IP_ADDRESS_SETTING_KEY];
  [self.ipAddressField setText:ipAddress];
  
  NSString *port = [defaults objectForKey:OUTGOING_PORT_SETTING_KEY];
  [self.outgoingPortField setText:port];
  
  port = [defaults objectForKey:INCOMING_PORT_SETTING_KEY];
  [self.incomingPortField setText:port];
  
  bool useCap = [defaults boolForKey:USE_SCREEN_CAPTURE_SETTING_KEY];
  [self.useScreenCatpture setOn:useCap];
  
  NSString *rate = [defaults objectForKey:FRAME_RATE_SETTING_KEY];
  [self.frameRateField setText:rate];
}

- (void)commitSettingsToUserDefaults
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  NSNumber *val = [NSNumber numberWithFloat:self.sensitivitySlider.value];
  [defaults setObject:val
               forKey:SENSITIVITY_SETTING_KEY];
  
  [defaults setObject:self.ipAddressField.text
               forKey:IP_ADDRESS_SETTING_KEY];
  
  [defaults setObject:self.outgoingPortField.text
               forKey:OUTGOING_PORT_SETTING_KEY];
  
  [defaults setObject:self.incomingPortField.text
               forKey:INCOMING_PORT_SETTING_KEY];
  
  [defaults setBool:self.useScreenCatpture.on
             forKey:USE_SCREEN_CAPTURE_SETTING_KEY];
  
  [defaults setObject:self.frameRateField.text
               forKey:FRAME_RATE_SETTING_KEY];
  
  [defaults setBool:TRUE forKey:SAVED_SETTING_KEY];
  
  [defaults synchronize];
}


@end
