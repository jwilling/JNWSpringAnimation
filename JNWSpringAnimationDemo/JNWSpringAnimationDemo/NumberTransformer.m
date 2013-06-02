//
//  NumberTransformer.m
//  JNWSpringAnimationDemo
//
//  Created by Jonathan Willing on 2/17/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "NumberTransformer.h"

@implementation NumberTransformer

+ (Class)transformedValueClass {
    return [NSNumber class];
}

- (id)transformedValue:(id)value {
	return @([value integerValue]);
}

@end
