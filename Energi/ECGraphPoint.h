//
//  ECGraphPoint.h
//  Energi
//
//  Created by Scott Boyd on 04/01/2014.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECGraphPoint : NSObject {
	NSDate		*xDateValue;
	NSDate		*yDateValue;
	int			xValue;
	int			yValue;
	NSString	*data;
}

@property(nonatomic,assign) int xValue;
@property(nonatomic,assign) int yValue;
@property(nonatomic,retain) NSDate *xDateValue;
@property(nonatomic,retain) NSDate *yDateValue;
@property(nonatomic,retain) NSString *data;

@end