//
//  PieChartView.m
//  Energi
//
//  Created by Scott Boyd on 25/10/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "PieChartView.h"

@implementation PieChartView

- (void)dealloc
{
    self.rotatedView.delegate = nil;
    self.rotatedView = nil;
    self.centerView = nil;
    self.amountLabel = nil;
}

- (id)initWithFrame:(CGRect)frame withValue:(NSMutableArray *)valueArr withColor:(NSMutableArray *)colorArr withTitle:(NSMutableArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self sortValueArr:valueArr colorArr:colorArr titleArr:titleArr];
        self.rotatedView = [[RotatedView alloc]initWithFrame:self.bounds];
        self.rotatedView.mValueArray = valueArr;
        self.rotatedView.mColorArray = colorArr;
        self.rotatedView.mTitleArray = titleArr;
        self.rotatedView.delegate = self;
        [self addSubview:self.rotatedView];
        
        // Start of centre view code
        self.centerView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.centerView removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.centerView addTarget:self action:@selector(changeInOut:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *centerImage = [UIImage imageNamed:@"center.png"];
        [self.centerView setBackgroundImage:centerImage forState:UIControlStateNormal];
        [self.centerView setBackgroundImage:centerImage forState:UIControlStateHighlighted];
        self.centerView.frame = CGRectMake((frame.size.width - centerImage.size.width/2)/2, (frame.size.height - centerImage.size.height/2)/2, centerImage.size.width/2, centerImage.size.height/2);
        int titleWidth = 65;
        self.title = [[UILabel alloc]initWithFrame:CGRectMake((centerImage.size.width/2 - titleWidth)/2,35 , titleWidth, 17)];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.font = [UIFont systemFontOfSize:16];
        self.title.textColor = [self colorFromHexRGB:@"cecece"];
        self.title.text = @"";
        [self.centerView addSubview:self.title];
        
        int amountWidth = 75;
        self.amountLabel = [[UILabel alloc]initWithFrame:CGRectMake((centerImage.size.width/2 - amountWidth)/2, 53, amountWidth, 22)];
        self.amountLabel.backgroundColor = [UIColor clearColor];
        self.amountLabel.textAlignment = NSTextAlignmentCenter;
        self.amountLabel.font = [UIFont boldSystemFontOfSize:21];
        self.amountLabel.textColor = [self colorFromHexRGB:@"ffffff"];
        [self.amountLabel setAdjustsFontSizeToFitWidth:YES];
        [self.centerView addSubview:self.amountLabel];
        
        [self addSubview:self.centerView];
        // End of Centre View code
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)sortValueArr:(NSMutableArray *)valueArr colorArr:(NSMutableArray *)colorArr titleArr:(NSMutableArray *)titleArr
{
    float sum = 0.0;
    int maxIndex = 0;
    int maxValue = 0;
    for (int i = 0; i < [valueArr count]; i++) {
        float curValue = [[valueArr objectAtIndex:i] floatValue];
        if (curValue > maxValue) {
            maxValue = curValue;
            maxIndex = i;
        }
        sum += curValue;
    }
    float frac = 2.0 * M_PI / sum;
    int changeIndex = 0;
    sum = 0.0;
    for (int i = 0; i < [valueArr count]; i++) {
        float curValue = [[valueArr objectAtIndex:i] floatValue];
        sum += curValue;
        if(sum*frac > M_PI/2){
            changeIndex = i;
            break;
        }
    }
    if (maxIndex != changeIndex) {
        [valueArr exchangeObjectAtIndex:maxIndex withObjectAtIndex:changeIndex];
        [colorArr exchangeObjectAtIndex:maxIndex withObjectAtIndex:changeIndex];
        [titleArr exchangeObjectAtIndex:maxIndex withObjectAtIndex:changeIndex];
    }
}

- (void)changeInOut:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onCenterClick:)]) {
        [self.delegate onCenterClick:self];
    }
}

- (void)setTitleText:(NSString *)text
{
    [self.title setText:text];
}

- (void)setAmountText:(NSString *)text
{
    [self.amountLabel setText:text];
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

- (void)reloadChart
{
    [self.rotatedView reloadPie];
}

- (void)selectedFinish:(RotatedView *)rotatedView index:(NSInteger)index percent:(float)per title:(NSString *)title
{
    [self.delegate selectedFinish:self index:index percent:per title:title];
}

@end
