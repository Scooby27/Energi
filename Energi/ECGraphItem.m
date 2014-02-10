//
//  ECGraphItem.m
//  Energi
//
//  Created by Scott Boyd on 04/01/2014.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "ECGraphItem.h"

@implementation ECGraphItem

@synthesize name;
@synthesize color;
@synthesize yValue;
@synthesize yDateValue;
@synthesize isYDate;
@synthesize isPercentage;
@synthesize width;
@synthesize max;
@synthesize per;

- (id)init{
	if(self = [super init]){
		name = @"";
		color = nil;
		yDateValue = nil;
	}
	return self;
}

@end