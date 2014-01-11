//
//  ECGraphLine.h
//  Energi
//
//  Created by Scott Boyd on 04/01/2014.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECGraphLine : NSObject {
	NSArray	*points;		//ECGraphPoint Array
	NSString	*name;			//line name
	UIColor	*color;			//line color
	BOOL		isXDate;
	BOOL		isYDate;
}

@property(nonatomic,retain) NSArray *points;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) UIColor *color;
@property(nonatomic,assign)	BOOL isXDate;
@property(nonatomic,assign) BOOL isYDate;

@end