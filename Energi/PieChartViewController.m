//
//  PieChartViewController.m
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
    self.titleArray = nil;
    self.valueArray2 = nil;
    self.colorArray2 = nil;
    self.titleArray2 = nil;
    self.pieContainer = nil;
    self.selLabel = nil;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inOut = YES;
    
    DataClass *obj = [DataClass getInstance];
    self.IDlbl.text = [NSString stringWithFormat:@"ID: %@", obj.houseID];
    // Creates a label notifying the household that is currently logged in.
    
    self.picker.delegate = self;
    // Shows the picker on the view.
    
    self.displayRangeLbl.text = [NSString stringWithFormat:@"Activity over Day: %@", obj.dataDate];
    // Creates a label containign data about the time range.
    
    int startValue = obj.startValue;
    int endValue = obj.endValue;
    
    self.valueArray = [[NSMutableArray alloc] init];
    self.valueArray2 = [[NSMutableArray alloc] init];
    self.colorArray = obj.colorArray;
    self.colorArray2 = obj.colorArray2;
    self.titleArray = [[NSMutableArray alloc] init];
    self.titleArray2 = [[NSMutableArray alloc] init];
    
    for (int i = startValue; i < endValue; i++){
        [self.valueArray addObject:[obj.valueArray objectAtIndex:i]];
        [self.titleArray addObject:[obj.titleArray objectAtIndex:i]];
    }
    
    for (int i = startValue; i < endValue; i++){
        [self.valueArray2 addObject:[obj.valueArray2 objectAtIndex:i]];
        [self.titleArray2 addObject:[obj.titleArray2 objectAtIndex:i]];
    }
    // Sets the values for each certain day.
    
    //add shadow img
    CGRect pieFrame = CGRectMake((self.view.frame.size.width - PIE_HEIGHT) / 2, 100-0, PIE_HEIGHT, PIE_HEIGHT);
        
    UIImage *shadowImg = [UIImage imageNamed:@"shadow.png"];
    UIImageView *shadowImgView = [[UIImageView alloc]initWithImage:shadowImg];
    shadowImgView.frame = CGRectMake(0, pieFrame.origin.y + PIE_HEIGHT, shadowImg.size.width/2, shadowImg.size.height/2);
    [self.view addSubview:shadowImgView];
        
    self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray withTitle:self.titleArray withCenter:false];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
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

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per title:(NSString *)title{
    
    if(self.inOut){
        self.selLabel.text = [NSString stringWithFormat:@"Time of Day: %@ - %@", title, [NSString stringWithFormat:@"%.2f kWh", per/1000]];
    }else{
        self.selLabel.text = [NSString stringWithFormat:@"Time of Day: %@ - %@", title, [NSString stringWithFormat:@"£%.2f", 0.09*per/1000]];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    DataClass *obj = [DataClass getInstance];
    int numberOfDates = (int)([obj.dateArray count]-2)/2;
    // The -2 here ensures that the blank values to indiacte the end are not counted as a selection.
    return numberOfDates;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    DataClass *obj = [DataClass getInstance];
    return [obj.dateArray objectAtIndex:2*row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DataClass *obj = [DataClass getInstance];
    obj.startValue = [[obj.dateArray objectAtIndex:(2*row + 1)] intValue];
    obj.endValue = [[obj.dateArray objectAtIndex:(2*row + 3)] intValue];
    obj.dataDate = [[NSString alloc] init];
    obj.dataDate = [[pickerView delegate] pickerView:pickerView titleForRow:row forComponent:0];
    // Sets the date to the one selected to show what date is being viewed.
    
}

- (IBAction)changeUnits:(id)sender{
    
    [self onCenterClick:self.pieChartView];
    // Without a centre, a separate button is pressed to give the same effect.
    
    if (self.inOut){
        [self.changeUnitsButton setTitle:@"Cost" forState:UIControlStateNormal];
    }else{
        [self.changeUnitsButton setTitle:@"Energy" forState:UIControlStateNormal];
    }
    // Change text depending on current setting.
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    self.inOut = !self.inOut;
    self.pieChartView.delegate = nil;
    [self.pieChartView removeFromSuperview];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.inOut?self.colorArray:self.colorArray2 withTitle:self.inOut?self.titleArray:self.titleArray2 withCenter:false];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView reloadChart];
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
