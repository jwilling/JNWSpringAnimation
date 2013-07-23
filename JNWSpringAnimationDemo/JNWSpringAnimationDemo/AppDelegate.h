//
//  AppDelegate.h
//  JNWSpringAnimationDemo
//
//  Created by Jonathan Willing on 2/15/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, assign) IBOutlet NSWindow *window;

@property (nonatomic, assign) IBOutlet NSView *containerView;
@property (nonatomic, strong) CALayer *redBox;
@property (nonatomic, weak) IBOutlet NSTextField *codeVariableName;

- (IBAction)animate:(id)sender;
- (IBAction)sliderDidChange:(id)sender;
- (IBAction)copyCode:(id)sender;

@end
