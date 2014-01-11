//
//  ECGraphPoint.m
//  Energi
//
//  Created by Scott Boyd on 04/01/2014.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "ECGraphPoint.h"

@implementation ECGraphPoint

@synthesize xValue;
@synthesize yValue;
@synthesize data;
@synthesize xDateValue;
@synthesize yDateValue;

- (id)init{
	if(self = [super init]){
		xValue = 0;
		yValue = 0;
		data = @"";
		xDateValue = nil;
		yDateValue = nil;
	}
	return self;
}

@end