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
    ECGraph *graph = [[ECGraph alloc] initWithFrame:CGRectMake(7,100, 330, 310)
                                        withContext:_context isPortrait:YES];
    
    DataClass *obj = [DataClass getInstance];
    
    NSArray *valueArray = obj.valueArray;
    NSArray *colorArray = obj.colorArray;
    NSArray *titleArray = obj.titleArray;
    
    int categories_count = (int)[valueArray count];
    int barLength = 175/categories_count;
    int total_value = 0;
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:nil];
    
    float max = 0;
    for (int i = 0; i < categories_count; i++){
        float value = [[valueArray objectAtIndex:i] floatValue];
        
        if (max < value){
            max = value;
        }
        total_value += [[valueArray objectAtIndex:i] integerValue];
    }
    
    for (int i = 0; i < categories_count; i++){
        
        float value = [[valueArray objectAtIndex:i] floatValue];
        
        float per = 100*(value/total_value);
        
        ECGraphItem *item = [[ECGraphItem alloc] init];
        item.isPercentage = NO;
        item.yValue = value;
        item.width = barLength;
        item.name = [titleArray objectAtIndex:i];
        item.color =[colorArray objectAtIndex:i];
        item.max = 1.2*max;
        item.per = per;
        [items addObject:item];
    }
    
    [graph setXaxisTitle:@"Time of Day"];
    [graph setYaxisTitle:@"Energy Consumption (Wh)"];
    [graph setGraphicTitle:[NSString stringWithFormat:@"Activity over Day: %@", obj.dataDate]];
    [graph setDelegate:self];
    [graph setBackgroundColor:[UIColor whiteColor]];
    [graph drawHistogramWithItems:items lineWidth:2 color:[UIColor blackColor]];
	
}



@end
