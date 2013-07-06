//
//  AppDelegate.m
//  JNWSpringAnimationDemo
//
//  Created by Jonathan Willing on 2/15/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "AppDelegate.h"
#import "JNWSpringAnimation.h"

@interface AppDelegate()
@property (nonatomic, strong) NSNumber *stiffness;
@property (nonatomic, strong) NSNumber *damping;
@property (nonatomic, strong) NSNumber *mass;

@property (nonatomic, strong) NSNumber *animationType;
@end

static const NSInteger boxInset = 50;
static const NSInteger boxLength = 50;

@implementation AppDelegate {
	BOOL _toggled;
}

- (void)awakeFromNib {
	self.stiffness = @(300);
	self.damping = @(30);
	self.mass = @(6);
	
	self.containerView.layer = [CALayer layer];
	self.containerView.wantsLayer = YES;
	self.containerView.layer.backgroundColor = [NSColor colorWithCalibratedWhite:0.661 alpha:1.000].CGColor;
	
	self.redBox = [CALayer layer];
	self.redBox.backgroundColor = [NSColor redColor].CGColor;
	self.redBox.bounds = CGRectMake(0, 0, boxLength, boxLength);
	self.redBox.position = CGPointMake(boxInset, CGRectGetHeight(self.containerView.bounds) / 2);
	
	[self.containerView.layer addSublayer:self.redBox];
}

- (void)animate:(id)sender {
	JNWSpringAnimation *animation = [JNWSpringAnimation animationWithKeyPath:nil];
	animation.stiffness = self.stiffness.floatValue;
	animation.damping = self.damping.floatValue;
	animation.mass = self.mass.floatValue;
	
	NSString *keyPath = nil;
	
	switch (self.animationType.intValue) {
		case 0:
			keyPath = @"position.x";
			animation.toValue = @(CGRectGetWidth(self.containerView.bounds) - boxInset);
			animation.fromValue = @(boxInset);
			break;
		case 1:
			keyPath = @"position";
			animation.toValue = [NSValue valueWithPoint:CGPointMake(300, 60)];
			animation.fromValue = [NSValue valueWithPoint:self.redBox.position];
			break;
		case 2:
			keyPath = @"cornerRadius";
			animation.toValue = @15;
			animation.fromValue = @0;
			break;
		case 3:
			keyPath = @"transform.scale";
			animation.toValue = @1;
			animation.fromValue = @0;
			break;
		case 4:
			keyPath = @"transform.rotation.z";
			animation.toValue = @(M_PI);
			animation.fromValue = @0;
			break;
		case 5:
			// Remember that the `frame` property of a CALayer is not animatable since it is a derived property.
			// To animate the frame you'd need to use a combination of `bounds` and `position` animations.
			keyPath = @"bounds";
			animation.toValue = [NSValue valueWithRect:CGRectMake(0, 0, 130, 130)];
			animation.fromValue = [NSValue valueWithRect:self.redBox.bounds];
			break;
		case 6:
			keyPath = @"transform";
			CATransform3D transform = CATransform3DIdentity;
			transform.m34 = -1.0 / 90.0;
			transform = CATransform3DRotate(transform, M_PI_2 - .01, 1, 0, 0);
			animation.fromValue = [NSValue valueWithCATransform3D:transform];
			animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
			break;
			
		default:
			break;
	}
	
	animation.keyPath = keyPath;
	animation.delegate = self;
	
	NSLog(@"%@",animation);
	
	[self.redBox addAnimation:animation forKey:keyPath];
}

- (IBAction)sliderDidChange:(id)sender {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self performSelector:@selector(animate:) withObject:self afterDelay:0.3];
}

- (IBAction)copyCode:(id)sender {
	NSString *varName = @"spring";
	if ([self.codeVariableName.stringValue length] > 0) {
		varName = self.codeVariableName.stringValue;
	}
	
	NSString *code = [NSString stringWithFormat:@"%@.damping = %.2f;\n%@.stiffness = %.2f;\n%@.mass = %.2f;", varName, [self.damping floatValue], varName, [self.stiffness floatValue], varName, [self.mass floatValue]];
	
	
	NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
	[pasteBoard declareTypes:@[NSPasteboardTypeString] owner:nil];
	[pasteBoard setString:code forType:NSPasteboardTypeString];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	NSLog(@"Animation completed.");
}

@end
