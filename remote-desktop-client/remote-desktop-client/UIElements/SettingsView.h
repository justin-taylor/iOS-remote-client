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

/**
 Returns whether any instance of a SettingsView has commited it's settings to
 UserDefaults
 */
+ (BOOL)hasSavedSettings;

/**
 Loads the user's saved settings and updates the ui with the data
 */
- (void)loadSettingsFromUserDefaults;

/**
 Saves the current values from all the input fields and commits them to the
 user defaults
 */
- (void)commitSettingsToUserDefaults;

/**
 Animates the view's location to either display the screen or hide it
 
 @param show True displays the view. Fales hides the view.
 */
- (void)setVisible:(BOOL)show;

@end


@protocol SettingsViewDelegate <NSObject>

- (void)settingsViewReceivedConnectAction:(SettingsView *)view;
- (void)settingsView:(SettingsView *)view didBecomeVisible:(BOOL)visible;

@end