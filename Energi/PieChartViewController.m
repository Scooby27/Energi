//
//  GraphViewController.m
//  Energi
//
//  Created by Scott Boyd on 18/12/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "PieChartViewController.h"

#define PIE_HEIGHT 230

@implementation PieChartViewController

- (void)dealloc
{
    self.valueArray = nil;
    self.colorArray = nil;
    self.valueArray2 = nil;
    self.colorArray2 = nil;
    self.pieContainer = nil;
    self.selLabel = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inOut = YES;
    self.valueArray = [[NSMutableArray alloc] initWithObjects:
                       [NSNumber numberWithInt:2],
                       [NSNumber numberWithInt:3],
                       [NSNumber numberWithInt:2],
                       [NSNumber numberWithInt:3],
                       [NSNumber numberWithInt:3],
                       [NSNumber numberWithInt:4],
                       nil];
    self.valueArray2 = [[NSMutableArray alloc] initWithObjects:
                        [NSNumber numberWithInt:3],
                        [NSNumber numberWithInt:2],
                        [NSNumber numberWithInt:2],
                        nil];
    
    self.colorArray = [NSMutableArray arrayWithObjects:
                       [UIColor colorWithHue:((0/8)%20)/20.0+0.28 saturation:(0%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((1/8)%20)/20.0+0.28 saturation:(1%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((2/8)%20)/20.0+0.28 saturation:(2%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((3/8)%20)/20.0+0.28 saturation:(3%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((4/8)%20)/20.0+0.28 saturation:(4%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((5/8)%20)/20.0+0.28 saturation:(5%8+3)/10.0 brightness:91/100.0 alpha:1],
                       nil];
    self.colorArray2 = [[NSMutableArray alloc] initWithObjects:
                        [UIColor colorWithHue:((1/4)%20)/20.0+0.1 saturation:(4%8+3)/10.0 brightness:91/100.0 alpha:1],
                        [UIColor colorWithHue:((2/4)%20)/20.0+0.1 saturation:(6%8+3)/10.0 brightness:91/100.0 alpha:1],
                        [UIColor colorWithHue:((3/4)%20)/20.0+0.1 saturation:(7%8+3)/10.0 brightness:91/100.0 alpha:1], nil];
    
    //add shadow img
    CGRect pieFrame = CGRectMake((self.view.frame.size.width - PIE_HEIGHT) / 2, 100-0, PIE_HEIGHT, PIE_HEIGHT);
    
    UIImage *shadowImg = [UIImage imageNamed:@"shadow.png"];
    UIImageView *shadowImgView = [[UIImageView alloc]initWithImage:shadowImg];
    shadowImgView.frame = CGRectMake(0, pieFrame.origin.y + PIE_HEIGHT, shadowImg.size.width/2, shadowImg.size.height/2);
    [self.view addSubview:shadowImgView];
    
    self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView setAmountText:@"100"];
    [self.view addSubview:self.pieContainer];
    
    //add selected view
    UIImageView *selView = [[UIImageView alloc]init];
    selView.image = [UIImage imageNamed:@"select.png"];
    selView.frame = CGRectMake((self.view.frame.size.width - selView.image.size.width/2)/2, self.pieContainer.frame.origin.y + self.pieContainer.frame.size.height + 10, selView.image.size.width/2, selView.image.size.height/2);
    [self.view addSubview:selView];
    
    self.selLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, selView.image.size.width/2, 21)];
    self.selLabel.backgroundColor = [UIColor clearColor];
    self.selLabel.textAlignment = NSTextAlignmentCenter;
    self.selLabel.font = [UIFont systemFontOfSize:17];
    self.selLabel.textColor = [UIColor whiteColor];
    [selView addSubview:self.selLabel];
    [self.pieChartView setTitleText:@"Energy"];
    self.title = @"Cost";
}

- (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
    self.selLabel.text = [NSString stringWithFormat:@"%2.2f%@",per*100,@"%"];
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    self.inOut = !self.inOut;
    self.pieChartView.delegate = nil;
    [self.pieChartView removeFromSuperview];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.inOut?self.valueArray:self.valueArray2 withColor:self.inOut?self.colorArray:self.colorArray2];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView reloadChart];
    
    if (self.inOut) {
        [self.pieChartView setTitleText:@"Energy"];
        [self.pieChartView setAmountText:@"100 kw/h"];
        
    }else{
        [self.pieChartView setTitleText:@"Cost"];
        [self.pieChartView setAmountText:@"£50"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.pieChartView reloadChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
