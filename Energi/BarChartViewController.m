//
//  BarChartViewController.m
//  Energi
//
//  Created by Scott Boyd on 19/12/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "BarChartViewController.h"

@interface BarChartViewController ()

@end

@implementation BarChartViewController

- (id)initWithFrame:(CGRect)frame {
   
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef _context = UIGraphicsGetCurrentContext();
    ECGraph *graph = [[ECGraph alloc] initWithFrame:CGRectMake(10,10, 480, 320)
                                        withContext:_context isPortrait:NO];
    ECGraphItem *item1 = [[ECGraphItem alloc] init];
    item1.isPercentage = YES;
    item1.yValue = 80;
    item1.width = 35;
    item1.name = @"item1";
    
    ECGraphItem *item2 = [[ECGraphItem alloc] init];
    item2.isPercentage = YES;
    item2.yValue = 35.3;
    item2.width = 35;
    item2.name = @"item2";
    
    ECGraphItem *item3 = [[ECGraphItem alloc] init];
    item3.isPercentage = YES;
    item3.yValue = 45;
    item3.width = 35;
    item3.name = @"item3";
    
    ECGraphItem *item4 = [[ECGraphItem alloc] init];
    item4.isPercentage = YES;
    item4.yValue = 78.6;
    item4.width = 35;
    item4.name = @"item4";
    
    ECGraphItem *item5 = [[ECGraphItem alloc] init];
    item5.isPercentage = YES;
    item5.yValue = 94.45;
    item5.width = 35;
    item5.name = @"item5";
    
    NSArray *items = [[NSArray alloc] initWithObjects:item1,item2,item3,item4,item5,nil];
    [graph setXaxisTitle:@"name"];
    [graph setYaxisTitle:@"Percentage"];
    [graph setGraphicTitle:@"Histogram"];
    [graph setDelegate:self];
    [graph setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]];
    [graph drawHistogramWithItems:items lineWidth:2 color:[UIColor blackColor]];
	
	//ECGraphItem *item1 = [[ECGraphItem alloc] init];
    //	item1.isPercentage = YES;
    //	item1.yValue = 80;
    //	item1.width = 35;
    //	item1.name = @"item1";
    //
    //	ECGraphItem *item2 = [[ECGraphItem alloc] init];
    //	item2.isPercentage = YES;
    //	item2.yValue = 35.3;
    //	item2.width = 35;
    //	item2.name = @"item2";
    //
    //	ECGraphItem *item3 = [[ECGraphItem alloc] init];
    //	item3.isPercentage = YES;
    //	item3.yValue = 45;
    //	item3.width = 35;
    //	item3.name = @"item3";
    //
    //	ECGraphItem *item4 = [[ECGraphItem alloc] init];
    //	item4.isPercentage = YES;
    //	item4.yValue = 78.6;
    //	item4.width = 35;
    //	item4.name = @"item4";
    //
    //	ECGraphItem *item5 = [[ECGraphItem alloc] init];
    //	item5.isPercentage = YES;
    //	item5.yValue = 94.45;
    //	item5.width = 35;
    //	item5.name = @"item5";
    //
    //	NSArray *items = [[NSArray alloc] initWithObjects:item1,item2,item3,item4,item5,nil];
    //	[graph setXaxisTitle:@"name"];
    //	[graph setYaxisTitle:@"Percentage"];
    //	[graph setGraphicTitle:@"Histogram"];
    //	[graph setDelegate:self];
    //	[graph setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]];
    //	[graph drawHistogramWithItems:items lineWidth:2 color:[UIColor blackColor]];
	
}


//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//    CGContextRef _context = UIGraphicsGetCurrentContext();
//    ECGraph *graph = [[ECGraph alloc] initWithFrame:CGRectMake(10,10, 480, 320)
//                                        withContext:_context isPortrait:NO];
//    ECGraphItem *item1 = [[ECGraphItem alloc] init];
//    item1.isPercentage = YES;
//    item1.yValue = 80;
//    item1.width = 35;
//    item1.name = @"item1";
//    
//    ECGraphItem *item2 = [[ECGraphItem alloc] init];
//    item2.isPercentage = YES;
//    item2.yValue = 35.3;
//    item2.width = 35;
//    item2.name = @"item2";
//    
//    ECGraphItem *item3 = [[ECGraphItem alloc] init];
//    item3.isPercentage = YES;
//    item3.yValue = 45;
//    item3.width = 35;
//    item3.name = @"item3";
//    
//    ECGraphItem *item4 = [[ECGraphItem alloc] init];
//    item4.isPercentage = YES;
//    item4.yValue = 78.6;
//    item4.width = 35;
//    item4.name = @"item4";
//    
//    ECGraphItem *item5 = [[ECGraphItem alloc] init];
//    item5.isPercentage = YES;
//    item5.yValue = 94.45;
//    item5.width = 35;
//    item5.name = @"item5";
//    
//    NSArray *items = [[NSArray alloc] initWithObjects:item1,item2,item3,item4,item5,nil];
//    [graph setXaxisTitle:@"name"];
//    [graph setYaxisTitle:@"Percentage"];
//    [graph setGraphicTitle:@"Histogram"];
//    [graph setDelegate:self];
//    [graph setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]];
//    [graph drawHistogramWithItems:items lineWidth:2 color:[UIColor blackColor]];
//    
//}
//
//- (void)drawRect:(CGRect)rect {
//   
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
