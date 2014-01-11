//
//  DisplayView.m
//  Energi
//
//  Created by Scott Boyd on 04/01/2014.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "DisplayView.h"
#import "ECCommon.h"
#import "ECGraphPoint.h"
#import "ECGraphLine.h"
#import "ECGraphItem.h"


@implementation DisplayView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
	CGContextRef _context = UIGraphicsGetCurrentContext();
    ECGraph *graph = [[ECGraph alloc] initWithFrame:CGRectMake(7,-75, 330, 310)
                                        withContext:_context isPortrait:NO];
    
    DataClass *obj = [DataClass getInstance];
    
    NSArray *valueArray = obj.valueArray;
    NSArray *colorArray = obj.colorArray;
    NSArray *titleArray = obj.titleArray;
    
    int categories_count = (int)[valueArray count];
    int total_value = 0;
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:nil];
    
    
    for (int i = 0; i < categories_count; i++){
        total_value += [[valueArray objectAtIndex:i] integerValue];
        
    }
    
    for (int i = 0; i < categories_count; i++){
        
        float per = 100*[[valueArray objectAtIndex:i] floatValue]/total_value;
        
        ECGraphItem *item = [[ECGraphItem alloc] init];
        item.isPercentage = YES;
        item.yValue = per;
        item.width = 175/categories_count;
        item.name = [titleArray objectAtIndex:i];
        item.color = [colorArray objectAtIndex:i];
        
        [items addObject:item];
    }
    
    [graph setXaxisTitle:@"Appliance Group"];
    [graph setYaxisTitle:@"Percentage Share of Household"];
    [graph setGraphicTitle:@"Appliance Group Share"];
    [graph setDelegate:self];
    [graph setBackgroundColor:[UIColor whiteColor]];
    [graph drawHistogramWithItems:items lineWidth:2 color:[UIColor blackColor]];
	
}



@end
