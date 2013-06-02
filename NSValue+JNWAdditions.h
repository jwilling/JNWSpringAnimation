//
//  NSValue+JNWAdditions.h
//  JNWSpringAnimationDemo
//
//  Created by Jonathan Willing on 6/2/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (JNWAdditions)

- (CGRect)jnw_rectValue;
- (CGSize)jnw_sizeValue;
- (CGPoint)jnw_pointValue;

+ (NSValue *)jnw_valueWithRect:(CGRect)rect;
+ (NSValue *)jnw_valueWithSize:(CGSize)size;
+ (NSValue *)jnw_valueWithPoint:(CGPoint)point;

@end
