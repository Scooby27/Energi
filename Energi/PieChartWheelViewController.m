//
//  PieChartViewController.m
//  Energi
//
//  Created by Scott Boyd on 11/02/2014.
//  Copyright (c) 2014 Scott Boyd. All rights reserved.
//

#import "PieChartWheelViewController.h"

#define PIE_HEIGHT 230

@implementation PieChartWheelViewController

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
    
    self.displayRangeLbl.text = [NSString stringWithFormat:@"Activity over Day: %@", obj.dataDate];
    // Creates a label containign data about the time range.
    
    self.valueArray = obj.valueArray;
    self.colorArray = obj.colorArray;
    self.titleArray = obj.titleArray;
    
    //add shadow img
    CGRect pieFrame = CGRectMake((self.view.frame.size.width - PIE_HEIGHT) / 2, 100-0, PIE_HEIGHT, PIE_HEIGHT);
    
    UIImage *shadowImg = [UIImage imageNamed:@"shadow.png"];
    UIImageView *shadowImgView = [[UIImageView alloc]initWithImage:shadowImg];
    shadowImgView.frame = CGRectMake(0, pieFrame.origin.y + PIE_HEIGHT, shadowImg.size.width/2, shadowImg.size.height/2);
    [self.view addSubview:shadowImgView];
    
    self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray withTitle:self.titleArray withCenter:true];
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
    
    
    //    // Display error message if unsuccessful connection.
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Warning!" message:@"Cannot connect to Energi database. Please check your internet connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //    // Sets up warning alert.
    //
    //    [alert show];
    //    // Show the alert.
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    // When the user achknowledges the warning, the app segues to the mani menu.
    if([[alertView title] isEqualToString:@"Connection Warning!"]){
        [self performSegueWithIdentifier:@"segue.to.menu" sender:self];
    }
}

- (BOOL) retrieveData{
    
    DataClass *obj = [DataClass getInstance];
    obj.titleArray = [[NSMutableArray alloc] init];
    obj.valueArray = [[NSMutableArray alloc] init];
    obj.colorArray = [[NSMutableArray alloc] init];
    obj.dataDate = [[NSString alloc] init];
    
    NSString *houseID = obj.houseID;
    
    NSString *getDataURL = [NSString stringWithFormat:@"http://localhost/%@.php", houseID];
    NSURL *url = [NSURL URLWithString:getDataURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    _json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if(!_json){ // If cannot connect to database, return false.
        
        return false;
        
    }else{
        NSString *dateAndTime;
        NSString *value;
        // Initialise time and value strings.
        
        NSMutableArray *datesAndTimes = [[NSMutableArray alloc] init];
        NSMutableArray *dtValues = [[NSMutableArray alloc] init];
        // Initialise arrays to store which times have been seen previously, so that a total can be calculated.
        
        NSString * date = [[NSString alloc] init];
        
        for(int i = 0; i < [_json count]; i++){
            
            dateAndTime = [[_json objectAtIndex:i]objectForKey:@"time"];
            value = [[_json objectAtIndex:i]objectForKey:@"value"];
            
            BOOL timeSeen = false;
            
            for(int j = 0; j < [datesAndTimes count]; j++){
                timeSeen = false;
                if([[datesAndTimes objectAtIndex:j] isEqualToString:dateAndTime]){
                    timeSeen = true;
                    int newTotalValue = [[dtValues objectAtIndex:j] intValue] + (int)[value longLongValue];
                    [dtValues replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:newTotalValue]];
                    break;
                }
            }
            
            if(!timeSeen){
                [datesAndTimes addObject:dateAndTime];
                [dtValues addObject:[NSNumber numberWithLongLong:[value longLongValue]]];
            }
            
        }
        
        self.valueArray = [[NSMutableArray alloc] initWithObjects:nil];
        self.titleArray = [[NSMutableArray alloc] initWithObjects:nil];
        
        for (int i = 0; i < [datesAndTimes count]; i++){
            NSString *dt = [datesAndTimes objectAtIndex:i];
            NSArray *dtComp = [dt componentsSeparatedByString:@" "];
            NSString *time = [dtComp objectAtIndex:1];
            if (i == 0){date = [dtComp objectAtIndex:0]; obj.dataDate = date;}
            [self.titleArray addObject:time];
            
            [self.valueArray addObject:[dtValues objectAtIndex:i]];
        }
        
        //    NSString *urlString = @"http://textuploader.com/1ret/raw";
        //    // Retrieves the list of house IDs and respective appliances.
        //    NSURL *url = [NSURL URLWithString:urlString];
        //
        //    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
        //    [_requestWebView loadRequest:request];
        //
        //    NSString *houseAppliances = [NSString stringWithContentsOfURL:url encoding:1 error:NULL];
        //
        //    NSArray *houseIDs_appliances = [houseAppliances componentsSeparatedByString:@"\n"];
        //
        //    NSMutableArray *usersAppliances = [[NSMutableArray alloc] init];
        //
        //    for (int i = 1; i < [houseIDs_appliances count]-1; i++){
        //        NSString *houseID_appliance = [houseIDs_appliances objectAtIndex:i];
        //        NSArray *combinations = [houseID_appliance componentsSeparatedByString:@","];
        //        NSString *nextID = [combinations objectAtIndex:0];
        //        NSString *nextAppliance = [combinations objectAtIndex:1];
        //        if ([houseID longLongValue] == [nextID longLongValue]){
        //            [usersAppliances insertObject:nextAppliance atIndex:0];
        //            // Adds appliance to a mutable array for categorising into appliance types.
        //        }
        //    }
        //
        //    urlString = @"http://textuploader.com/1rer/raw";
        //    // Retrieves the appliance codes and their respective grouping.
        //    url = [NSURL URLWithString:urlString];
        //
        //    request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
        //    [_requestWebView loadRequest:request];
        //
        //    NSString *applianceCodes = [NSString stringWithContentsOfURL:url encoding:1 error:NULL];
        //    NSArray *codes_groupings = [applianceCodes componentsSeparatedByString:@"\n"];
        //
        //    BOOL applianceFound = 0;
        //
        //    for (int j = 0; j < [usersAppliances count]; j++){
        //        applianceFound = 0;
        //        NSString *applianceCode = [usersAppliances objectAtIndex:j];
        //        for (int i = 1; i < [codes_groupings count]-1; i++){
        //            NSString *code_grouping = [codes_groupings objectAtIndex:i];
        //            NSArray *combinations = [code_grouping componentsSeparatedByString:@","];
        //            NSString *nextApplianceCode = [combinations objectAtIndex:0];
        //            NSString *nextApplianceGroup = [combinations objectAtIndex:1];
        //
        //            if ([applianceCode longLongValue] == [nextApplianceCode longLongValue]){
        //                [usersAppliances replaceObjectAtIndex:j withObject:nextApplianceGroup];
        //                applianceFound = 1;
        //            }
        //        }
        //
        //        if (!applianceFound){[usersAppliances replaceObjectAtIndex:j withObject:@"Unknown"];}
        //    }
        //
        //
        //    urlString = @"http://textuploader.com/10dr/raw";
        //    // Retrieves the appliance group codes and their respective names.
        //    url = [NSURL URLWithString:urlString];
        //
        //    request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
        //    [_requestWebView loadRequest:request];
        //
        //    NSString *groupCodes = [NSString stringWithContentsOfURL:url encoding:1 error:NULL];
        //    NSArray *groupCodes_groupNames = [groupCodes componentsSeparatedByString:@"\n"];
        //
        //    for (int j = 0; j < [usersAppliances count]; j++){
        //        NSString *groupCode = [usersAppliances objectAtIndex:j];
        //        for (int i = 1; i < [groupCodes_groupNames count]-1; i++){
        //            NSString *groupCode_groupName = [groupCodes_groupNames objectAtIndex:i];
        //            NSArray *combinations = [groupCode_groupName componentsSeparatedByString:@","];
        //            NSString *nextGroupCode = [combinations objectAtIndex:0];
        //            NSString *nextGroupName = [combinations objectAtIndex:1];
        //
        //            if ([groupCode longLongValue] == [nextGroupCode longLongValue]){
        //                [usersAppliances replaceObjectAtIndex:j withObject:nextGroupName];
        //            }
        //        }
        //    }
        //
        //    int count = 0;
        //
        //    self.valueArray = [[NSMutableArray alloc] initWithObjects:nil];
        //    self.titleArray = [[NSMutableArray alloc] initWithObjects:nil];
        //
        //    NSMutableArray *seen = [[NSMutableArray alloc] init];
        //    BOOL seenFlag = 0;
        //
        //    for (int i = 0; i < [usersAppliances count]; i++){
        //        seenFlag = 0;
        //        count = 1;
        //        NSString *group = [usersAppliances objectAtIndex:i];
        //        group = [group stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //
        //        for (int j = 0; j < [seen count]; j++){
        //            if([group isEqualToString:[seen objectAtIndex:j]]){seenFlag = 1; break;}
        //        }
        //
        //        if (seenFlag){continue;}
        //
        //        [seen addObject:group];
        //
        //        for (int j = 0; j < [usersAppliances count]; j++){
        //            if (i == j) continue;
        //
        //            NSString *currentGroup = [usersAppliances objectAtIndex:j];
        //            currentGroup = [currentGroup stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //            if ([group isEqualToString:currentGroup]){
        //                count++;
        //                [seen addObject:group];
        //            }
        //        }
        //
        //        NSNumber *NScount = [NSNumber numberWithInt:count];
        //
        //        [self.valueArray addObject:NScount];
        //
        //        [self.titleArray addObject:group];
        //
        //        NSString *groupCount = [NSString stringWithFormat:@"%@,%i", group, count];
        //        [usersAppliances replaceObjectAtIndex:i withObject:groupCount];
        //
        //    }
        
        self.valueArray2 = [[NSMutableArray alloc] initWithObjects:
                            [NSNumber numberWithInt:1],
                            [NSNumber numberWithInt:2],
                            [NSNumber numberWithInt:5],
                            nil];
        
        int segmentCount = (int)[self.valueArray count];
        
        self.colorArray = [NSMutableArray arrayWithObjects:nil];
        self.colorArray2 = [NSMutableArray arrayWithObjects:nil];
        
        for (int i = 0; i < segmentCount; i++){
            int odd = 4;
            int even = 1;
            if (i%2 == 0){
                odd = 1;
                even = 4;
            }
            [self.colorArray addObject:[UIColor colorWithHue:((odd*i/segmentCount)%20)/20.0+0.28 saturation:(even*i%segmentCount+3)/10.0 brightness:91/100.0 alpha:1]];
            [self.colorArray2 addObject:[UIColor colorWithHue:((3*i/segmentCount/2)%20)/20.0+0.1 saturation:(3*i%segmentCount+3)/10.0 brightness:91/100.0 alpha:1]];
            
        }
        for (int i = 0; i < [self.valueArray count]; i++){
            [obj.valueArray addObject:[self.valueArray objectAtIndex:i]];
            [obj.colorArray addObject:[self.colorArray objectAtIndex:i]];
            [obj.titleArray addObject:[self.titleArray objectAtIndex:i]];
        }
        
        self.displayRangeLbl.text = [NSString stringWithFormat:@"Activity over Day: %@", obj.dataDate];
        
        return true;
    }
    
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
    self.selLabel.text = [NSString stringWithFormat:@"Time of Day: %@ - %@", title, [NSString stringWithFormat:@"%.2f kWh", per/1000]];
    [self.pieChartView setAmountText:[NSString stringWithFormat:@"%.2f kWh", per/1000]];
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    self.inOut = !self.inOut;
    self.pieChartView.delegate = nil;
    [self.pieChartView removeFromSuperview];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.inOut?self.colorArray:self.colorArray2 withTitle:self.titleArray withCenter:true];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView reloadChart];
    
    if (self.inOut) {
        [self.pieChartView setTitleText:@"Energy"];
        
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