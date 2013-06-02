//
//  NSValue+JNWAdditions.m
//  JNWSpringAnimationDemo
//
//  Created by Jonathan Willing on 6/2/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "NSValue+JNWAdditions.h"

@implementation NSValue (JNWAdditions)

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED

- (CGRect)jnw_rectValue {
	return [self CGRectValue];
}

- (CGSize)jnw_sizeValue {
	return [self CGSizeValue];
}

- (CGPoint)jnw_pointValue {
	return [self CGPointValue];
}

+ (NSValue *)jnw_valueWithRect:(CGRect)rect {
	return [self valueWithCGRect:rect];
}

+ (NSValue *)jnw_valueWithPoint:(CGPoint)point {
	return [self valueWithCGPoint:point];
}

+ (NSValue *)jnw_valueWithSize:(CGSize)size {
	return [self valueWithCGSize:size];
}

#elif TARGET_OS_MAC

- (CGRect)jnw_rectValue {
	return [self rectValue];
}

- (CGSize)jnw_sizeValue {
	return [self sizeValue];
}

- (CGPoint)jnw_pointValue {
	return [self pointValue];
}

+ (NSValue *)jnw_valueWithRect:(CGRect)rect {
	return [self valueWithRect:rect];
}

+ (NSValue *)jnw_valueWithPoint:(CGPoint)point {
	return [self valueWithPoint:point];
}

+ (NSValue *)jnw_valueWithSize:(CGSize)size {
	return [self valueWithSize:size];
}

#endif

@end
