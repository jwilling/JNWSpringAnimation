/*
 Copyright (c) 2013, Jonathan Willing. All rights reserved.
 Licensed under the MIT license <http://opensource.org/licenses/MIT>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
 to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
 TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

#import "JNWSpringAnimation.h"
#import "NSValue+JNWAdditions.h"

static const NSInteger JNWSpringAnimationKeyframes = 60;
static const CGFloat JNWSpringAnimationDefaultMass = 5.f;
static const CGFloat JNWSpringAnimationDefaultDamping = 30.f;
static const CGFloat JNWSpringAnimationDefaultStiffness = 300.f;
static const CGFloat JNWSpringAnimationKeyframeStep = 0.001f;
static const CGFloat JNWSpringAnimationMinimumThreshold = 0.0001f;

@interface JNWSpringAnimation()
@property (nonatomic, copy) NSArray *interpolatedValues;
@end

@implementation JNWSpringAnimation

#pragma mark Initialization

+ (instancetype)animationWithKeyPath:(NSString *)path {
	return [super animationWithKeyPath:path];
}

- (id)init {
	self = [super init];
	_mass = JNWSpringAnimationDefaultMass;
	_damping = JNWSpringAnimationDefaultDamping;
	_stiffness = JNWSpringAnimationDefaultStiffness;
	self.duration = 0.25;
	return self;
}

// Since animations are copied before they are added onto the layer, we
// take this opportunity to override the copy method and actually
// calculate the key frames, and move those over to the new animation.
- (id)copyWithZone:(NSZone *)zone {
	[self calculateInterpolatedValues];
	
	JNWSpringAnimation *copy = [super copyWithZone:zone];
	copy.interpolatedValues = self.interpolatedValues;
	copy.duration = self.interpolatedValues.count * JNWSpringAnimationKeyframeStep;
	copy.fromValue = self.fromValue;
	copy.stiffness = self.stiffness;
	copy.toValue = self.toValue;
	copy.damping = self.damping;
	copy.mass = self.mass;
	
	return copy;
}

#pragma mark API

- (void)setToValue:(id)toValue {
	_toValue = toValue;
}

- (void)setFromValue:(id)fromValue {
	_fromValue = fromValue;
}

- (void)setDuration:(CFTimeInterval)duration {
	[super setDuration:duration];
}

- (NSArray *)values {
	return self.interpolatedValues;
}

- (void)calculateInterpolatedValues {
	NSAssert(self.fromValue != nil && self.toValue != nil, @"fromValue and or toValue must not be nil.");
	NSArray *values = nil;
	
	if ([self.keyPath isEqualToString:@"position.x"] ||
		[self.keyPath isEqualToString:@"position.y"] ||
		[self.keyPath isEqualToString:@"cornerRadius"] ||
		[self.keyPath isEqualToString:@"shadowRadius"] ||
		[self.keyPath isEqualToString:@"transform.translation.x"] ||
		[self.keyPath isEqualToString:@"transform.translation.y"] ||
		[self.keyPath isEqualToString:@"transform.translation.z"] ||
		[self.keyPath rangeOfString:@"transform.rotation"].location != NSNotFound ||
		[self.keyPath rangeOfString:@"transform.scale"].location != NSNotFound) {
		values = [self valuesFrom:self.fromValue to:self.toValue map:^id(CGFloat value) {
			return @(value);
		}];
	} else if ([self.keyPath isEqualToString:@"position"]) {
		CGPoint fromValue = [self.fromValue jnw_pointValue];
		CGPoint toValue = [self.toValue jnw_pointValue];
		values = [self valuesFrom:@(fromValue.x) to:@(toValue.x) from:@(fromValue.y) to:@(toValue.y) map:^id(CGFloat value1, CGFloat value2) {
			return [NSValue jnw_valueWithPoint:CGPointMake(value1, value2)];
		}];
	}
	// This is not implemented correctly, and has therefore been omitted from the compatible key paths in the header
	else if ([self.keyPath isEqualToString:@"transform"]) {
		CATransform3D fromValue = [self.fromValue CATransform3DValue];
		CATransform3D toValue = [self.toValue CATransform3DValue];
		values = [self valuesFrom:@(fromValue.m11) to:@(toValue.m11) from:@(fromValue.m22) to:@(toValue.m22) from:@(fromValue.m33) to:@(toValue.m33) map:^id(CGFloat value1, CGFloat value2, CGFloat value3) {
			return [NSValue valueWithCATransform3D:CATransform3DMakeScale(value1, value2, value3)];
		}];
	} else if ([self.keyPath isEqualToString:@"transform.translation"]) {
		CGSize fromValue = [self.fromValue jnw_sizeValue];
		CGSize toValue = [self.toValue jnw_sizeValue];
		values = [self valuesFrom:@(fromValue.width) to:@(toValue.width) from:@(fromValue.height) to:@(toValue.height) map:^id(CGFloat value1, CGFloat value2) {
			return [NSValue jnw_valueWithSize:CGSizeMake(value1, value2)];
		}];
	} else if ([self.keyPath isEqualToString:@"bounds"]) { // the `frame` property is not animatable
		CGRect fromValue = [self.fromValue jnw_rectValue];
		CGRect toValue = [self.toValue jnw_rectValue];
		values = [self valuesFrom:@(fromValue.origin.x) to:@(toValue.origin.x) from:@(fromValue.origin.y) to:@(toValue.origin.y) from:@(fromValue.size.width) to:@(toValue.size.width) from:@(fromValue.size.height) to:@(toValue.size.height) map:^id(CGFloat value1, CGFloat value2, CGFloat value3, CGFloat value4) {
			return [NSValue jnw_valueWithRect:CGRectMake(value1, value2, value3, value4)];
		}];
	} else if ([self.keyPath isEqualToString:@"bounds.size"]) {
		CGSize fromValue = [self.fromValue jnw_sizeValue];
		CGSize toValue = [self.toValue jnw_sizeValue];
		values = [self valuesFrom:@(fromValue.width) to:@(toValue.width) from:@(fromValue.height) to:@(toValue.height) map:^id(CGFloat value1, CGFloat value2) {
			return [NSValue jnw_valueWithSize:CGSizeMake(value1, value2)];
		}];
	}
	
	self.interpolatedValues = values;
}

- (NSArray *)valuesFrom:(NSNumber *)from to:(NSNumber *)to map:(id (^)(CGFloat value))map {
	return [self valuesFrom:from to:to from:nil to:nil map:^id(CGFloat value1, CGFloat value2) {
		return map(value1);
	}];
}

- (NSArray *)valuesFrom:(NSNumber *)from1 to:(NSNumber *)to1 from:(NSNumber *)from2 to:(NSNumber *)to2 map:(id (^)(CGFloat value1, CGFloat value2))map {
	return [self valuesFrom:from1 to:to1 from:from2 to:to2 from:nil to:nil map:^id(CGFloat value1, CGFloat value2, CGFloat value3) {
		return map(value1, value2);
	}];
}

- (NSArray *)valuesFrom:(NSNumber *)from1 to:(NSNumber *)to1 from:(NSNumber *)from2 to:(NSNumber *)to2 from:(NSNumber *)from3 to:(NSNumber *)to3 map:(id (^)(CGFloat value1, CGFloat value2, CGFloat value3))map {
	return [self valuesFrom:from1 to:to1 from:from2 to:to2 from:from3 to:to3 from:nil to:nil map:^id(CGFloat value1, CGFloat value2, CGFloat value3, CGFloat value4) {
		return map(value1, value2, value3);
	}];
}

- (NSArray *)valuesFrom:(NSNumber *)from1 to:(NSNumber *)to1 from:(NSNumber *)from2 to:(NSNumber *)to2 from:(NSNumber *)from3 to:(NSNumber *)to3 from:(NSNumber *)from4 to:(NSNumber *)to4 map:(id (^)(CGFloat value1, CGFloat value2, CGFloat value3, CGFloat value4))map {
	CGFloat distance1 = to1.floatValue - from1.floatValue;
	CGFloat distance2 = to2.floatValue - from2.floatValue;
	CGFloat distance3 = to3.floatValue - from3.floatValue;
	CGFloat distance4 = to4.floatValue - from4.floatValue;
	
	CGFloat threshold1 = JNWSpringAnimationThreshold(fabsf(distance1));
	CGFloat threshold2 = JNWSpringAnimationThreshold(fabsf(distance2));
	CGFloat threshold3 = JNWSpringAnimationThreshold(fabsf(distance3));
	CGFloat threshold4 = JNWSpringAnimationThreshold(fabsf(distance4));
	
	CFTimeInterval step = JNWSpringAnimationKeyframeStep;
	CFTimeInterval elapsed = 0;
	
	CGFloat value1 = 0;
	CGFloat value2 = 0;
	CGFloat value3 = 0;
	CGFloat value4 = 0;
	
	NSMutableArray *valuesArray = [NSMutableArray array];
	while (YES) {
		
		CGFloat proposedValue1 = JNWAbsolutePosition(distance1, elapsed, 0, self.damping, self.mass, self.stiffness, from1.floatValue);
		CGFloat proposedValue2 = JNWAbsolutePosition(distance2, elapsed, 0, self.damping, self.mass, self.stiffness, from2.floatValue);
		CGFloat proposedValue3 = JNWAbsolutePosition(distance3, elapsed, 0, self.damping, self.mass, self.stiffness, from3.floatValue);
		CGFloat proposedValue4 = JNWAbsolutePosition(distance4, elapsed, 0, self.damping, self.mass, self.stiffness, from4.floatValue);
		
		if (JNWThresholdReached(value1, proposedValue1, to1.floatValue, threshold1) &&
			JNWThresholdReached(value2, proposedValue2, to2.floatValue, threshold2) &&
			JNWThresholdReached(value3, proposedValue3, to3.floatValue, threshold3) &&
			JNWThresholdReached(value4, proposedValue4, to4.floatValue, threshold4))
			break;
		
		value1 = proposedValue1;
		value2 = proposedValue2;
		value3 = proposedValue3;
		value4 = proposedValue4;
		
		[valuesArray addObject:map(value1, value2, value3, value4)];
		elapsed += step;
	}
	
	return valuesArray;
}

BOOL JNWThresholdReached(CGFloat previousValue, CGFloat proposedValue, CGFloat finalValue, CGFloat threshold) {
	CGFloat previousDifference = fabsf(proposedValue - previousValue);
	CGFloat finalDifference = fabsf(previousValue - finalValue);
	if (previousDifference <= threshold && finalDifference <= threshold) {
		return YES;
	}
	return NO;
}

BOOL JNWCalculationsAreComplete(CGFloat value1, CGFloat proposedValue1, CGFloat to1, CGFloat value2, CGFloat proposedValue2, CGFloat to2, CGFloat value3, CGFloat proposedValue3, CGFloat to3) {
	return ((fabs(proposedValue1 - value1) < JNWSpringAnimationKeyframeStep) && (fabs(value1 - to1) < JNWSpringAnimationKeyframeStep)
			&& (fabs(proposedValue2 - value2) < JNWSpringAnimationKeyframeStep) && (fabs(value2 - to2) < JNWSpringAnimationKeyframeStep)
			&& (fabs(proposedValue3 - value3) < JNWSpringAnimationKeyframeStep) && (fabs(value3 - to3) < JNWSpringAnimationKeyframeStep));
}

#pragma mark Harmonic oscillation


CGFloat JNWAngularFrequency(CGFloat k, CGFloat m, CGFloat b) {
	CGFloat w0 = sqrt(k / m);
	CGFloat frequency = sqrt(pow(w0, 2) - (pow(b, 2) / (4*pow(m, 2))));
	if (isnan(frequency)) frequency = 0;
	return frequency;
}

CGFloat JNWRelativePosition(CGFloat A, CGFloat t, CGFloat phi, CGFloat b, CGFloat m, CGFloat k) {
	if (A == 0) return A;
	CGFloat ex = (-b / (2 * m) * t);
	CGFloat freq = JNWAngularFrequency(k, m, b);
	return A * exp(ex) * cos(freq*t + phi);
}

CGFloat JNWAbsolutePosition(CGFloat A, CGFloat t, CGFloat phi, CGFloat b, CGFloat m, CGFloat k, CGFloat from) {
	return from + A - JNWRelativePosition(A, t, phi, b, m, k);
}

// This feels a bit hacky. I'm sure there's a better way to accomplish this.
CGFloat JNWSpringAnimationThreshold(CGFloat magnitude) {
	return JNWSpringAnimationMinimumThreshold * magnitude;
}

#pragma mark Description

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p> mass: %f, damping: %f, stiffness: %f, keyPath: %@, toValue: %@, fromValue %@", self.class, self, self.mass, self.damping, self.stiffness, self.keyPath, self.toValue, self.fromValue];
}

@end
