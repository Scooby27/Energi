//
//  ECGraphLine.m
//  Energi
//
//  Created by Scott Boyd on 04/01/2014.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//
#import "ECGraphLine.h"

@implementation ECGraphLine

@synthesize points;
@synthesize name;
@synthesize color;
@synthesize isXDate;
@synthesize isYDate;

- (id)init{
	if(self = [super init]){
		points = nil;
		name = @"";
		color = nil;
	}
	return self;
}

@end