//
//  GraphViewController.m
//  Energi
//
//  Created by Scott Boyd on 18/12/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "PieChartViewController.h"
#import "DataClass.h"

#define PIE_HEIGHT 230

@implementation PieChartViewController

- (void)dealloc
{
    self.valueArray = nil;
    self.colorArray = nil;
    self.titleArray = nil;
    self.valueArray2 = nil;
    self.colorArray2 = nil;
    self.pieContainer = nil;
    self.selLabel = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inOut = YES;
    
    DataClass *obj = [DataClass getInstance];
    NSString *houseID = obj.houseID;
    NSString *urlString = @"http://textuploader.com/1ret/raw";
    // Retrieves the list of house IDs and respective appliances.
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString *houseAppliances = [NSString stringWithContentsOfURL:url encoding:1 error:NULL];
    
    NSArray *houseIDs_appliances = [houseAppliances componentsSeparatedByString:@"\n"];
    
    NSMutableArray *usersAppliances = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < [houseIDs_appliances count]-1; i++){
        NSString *houseID_appliance = [houseIDs_appliances objectAtIndex:i];
        NSArray *combinations = [houseID_appliance componentsSeparatedByString:@","];
        NSString *nextID = [combinations objectAtIndex:0];
        NSString *nextAppliance = [combinations objectAtIndex:1];
        if ([houseID longLongValue] == [nextID longLongValue]){
            [usersAppliances insertObject:nextAppliance atIndex:0];
            // Adds appliance to a mutable array for categorising into appliance types.
        }
    }
    
    urlString = @"http://textuploader.com/1rer/raw";
    // Retrieves the appliance codes and their respective grouping.
    url = [NSURL URLWithString:urlString];
    
    NSString *applianceCodes = [NSString stringWithContentsOfURL:url encoding:1 error:NULL];
    NSArray *codes_groupings = [applianceCodes componentsSeparatedByString:@"\n"];
    
    for (int j = 0; j < [usersAppliances count]; j++){
        NSString *applianceCode = [usersAppliances objectAtIndex:j];
        for (int i = 1; i < [codes_groupings count]-1; i++){
            NSString *code_grouping = [codes_groupings objectAtIndex:i];
            NSArray *combinations = [code_grouping componentsSeparatedByString:@","];
            NSString *nextApplianceCode = [combinations objectAtIndex:0];
            NSString *nextApplianceGroup = [combinations objectAtIndex:1];
            
            if ([applianceCode longLongValue] == [nextApplianceCode longLongValue]){
                [usersAppliances replaceObjectAtIndex:j withObject:nextApplianceGroup];
            }
        }
    }
    
    
    urlString = @"http://textuploader.com/1re0/raw";
    // Retrieves the appliance group codes and their respective names.
    url = [NSURL URLWithString:urlString];
    
    NSString *groupCodes = [NSString stringWithContentsOfURL:url encoding:1 error:NULL];
    NSArray *groupCodes_groupNames = [groupCodes componentsSeparatedByString:@"\n"];
    
    for (int j = 0; j < [usersAppliances count]; j++){
        NSString *groupCode = [usersAppliances objectAtIndex:j];
        for (int i = 1; i < [groupCodes_groupNames count]-1; i++){
            NSString *groupCode_groupName = [groupCodes_groupNames objectAtIndex:i];
            NSArray *combinations = [groupCode_groupName componentsSeparatedByString:@","];
            NSString *nextGroupCode = [combinations objectAtIndex:0];
            NSString *nextGroupName = [combinations objectAtIndex:1];
            
            if ([groupCode longLongValue] == [nextGroupCode longLongValue]){
                [usersAppliances replaceObjectAtIndex:j withObject:nextGroupName];
            }
        }
    }
    
    int count = 0;
    
    self.valueArray = [[NSMutableArray alloc] initWithObjects:nil];
    self.titleArray = [[NSMutableArray alloc] initWithObjects:nil];
    
    for (int i = 0; i < [usersAppliances count]; i++){
        count = 1;
        NSString *group = [usersAppliances objectAtIndex:i];
        group = [group stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        for (int j = 0; j < [usersAppliances count]; j++){
            if (i == j) continue;
            NSString *currentGroup = [usersAppliances objectAtIndex:j];
            currentGroup = [currentGroup stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([group isEqualToString:currentGroup]){
                count++;
                [usersAppliances removeObjectAtIndex:j];
            }
        }
        
        NSNumber *NScount = [NSNumber numberWithInt:count];
        
        [self.valueArray addObject:NScount];
        
        [self.titleArray addObject:group];
        
        NSString *groupCount = [NSString stringWithFormat:@"%@,%i", group, count];
        [usersAppliances replaceObjectAtIndex:i withObject:groupCount];

    }
    
    self.valueArray2 = [[NSMutableArray alloc] initWithObjects:
                        [NSNumber numberWithInt:1],
                        [NSNumber numberWithInt:2],
                        [NSNumber numberWithInt:5],
                        nil];
    
    int segmentCount = (int)[self.valueArray count];
    
    self.colorArray = [NSMutableArray arrayWithObjects:nil];
    
    for (int i = 0; i < segmentCount; i++){
        [self.colorArray addObject:[UIColor colorWithHue:((i/segmentCount)%20)/20.0+0.28 saturation:(i%segmentCount+3)/10.0 brightness:91/100.0 alpha:1]];
        
    }
    
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
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray withTitle:self.titleArray];
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
    [self.pieChartView setTitleText:@"App \n Share"];
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

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per title:(NSString *)title
{
    self.selLabel.text = title;
    [self.pieChartView setAmountText:[NSString stringWithFormat:@"%2.2f%@",per*100,@"%"]];
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    self.inOut = !self.inOut;
    self.pieChartView.delegate = nil;
    [self.pieChartView removeFromSuperview];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.inOut?self.valueArray:self.valueArray2 withColor:self.inOut?self.colorArray:self.colorArray2 withTitle:self.titleArray];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView reloadChart];
    
    if (self.inOut) {
        [self.pieChartView setTitleText:@"Appliances"];
        
    }else{
        [self.pieChartView setTitleText:@"Cost"];
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
