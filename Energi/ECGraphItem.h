//
//  ECGraphItem.h
//  Energi
//
//  Created by Scott Boyd on 04/01/2014.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECGraphItem : NSObject {
	NSString	*name;
	UIColor	*color;
	float			yValue;
	NSDate		*yDateValue;
	BOOL		isYDate;
	BOOL		isPercentage;
	float			width;
}

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) UIColor *color;
@property(nonatomic,assign) float yValue;
@property(nonatomic,retain) NSDate *yDateValue;
@property(nonatomic,assign) BOOL isYDate;
@property(nonatomic,assign) BOOL isPercentage;
@property(nonatomic,assign) float width;

@end