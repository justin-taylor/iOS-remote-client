//
//  SettingsView.h
//  remote-desktop-client
//
//  Created by Justin Taylor on 3/24/13.
//  Copyright (c) 2013 Tayloredapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SettingsViewDelegate;

@interface SettingsView : UIView
<UITextFieldDelegate>

@property (nonatomic, retain) UISlider *sensitivitySlider;
@property (nonatomic, retain) UITextField *ipAddressField;
@property (nonatomic, retain) UITextField *outgoingPortField;
@property (nonatomic, retain) UISwitch *useScreenCatpture;
@property (nonatomic, retain) UITextField *incomingPortField;
@property (nonatomic, retain) UITextField *frameRateField;

@property (nonatomic, retain) id<SettingsViewDelegate> delegate;


+ (BOOL)hasSavedSettings;
- (void)loadSettingsFromUserDefaults;
- (void)commitSettingsToUserDefaults;
- (void)setVisible:(BOOL)show;

@end


@protocol SettingsViewDelegate <NSObject>

- (void)settingsViewReceivedConnectAction:(SettingsView *)view;

@end