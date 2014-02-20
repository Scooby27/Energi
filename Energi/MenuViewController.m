//
//  MenuViewController.m
//  Energi
//
//  Created by Scott Boyd on 13/11/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

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
	// Do any additional setup after loading the view, typically from a nib.
    
    
    DataClass *obj = [DataClass getInstance];
    self.IDlbl.text = [NSString stringWithFormat:@"ID: %@", obj.houseID];
    // Creates a label notifying the household that is currently logged in.
    
    obj.barGraphChangeUnit = true;
    // Initialises the boolean for changing units in the bar graph.
    
    if (!obj.hasLoaded){
        obj.hasLoaded = true;
        [self retrieveData];
    }
}

- (void) retrieveData{
    
    DataClass *obj = [DataClass getInstance];
    obj.titleArray = [[NSMutableArray alloc] init];
    obj.valueArray = [[NSMutableArray alloc] init];
    obj.colorArray = [[NSMutableArray alloc] init];
    obj.titleArray2 = [[NSMutableArray alloc] init];
    obj.valueArray2 = [[NSMutableArray alloc] init];
    obj.colorArray2 = [[NSMutableArray alloc] init];
    obj.dateArray = [[NSMutableArray alloc] init];
    
    NSString *houseID = obj.houseID;
    
    NSString *getDataURL = [NSString stringWithFormat:@"http://localhost/%@.php", houseID];
    NSURL *url = [NSURL URLWithString:getDataURL];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    
    if (!error){
        _json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }

    if (error || !_json) {
        // Display error message if unsuccessful connection.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Warning!" message:@"Cannot connect to Energi database. Please check your internet connection and try again." delegate:self cancelButtonTitle:@"Log Out" otherButtonTitles: nil];
        // Sets up warning alert.
        
        [alert show];
        // Show the alert.

    } else {
        
        NSString *dateAndTime;
        NSString *value;
        // Initialise time and value strings.
        
        NSMutableArray *datesAndTimes = [[NSMutableArray alloc] init];
        NSMutableArray *dtValues = [[NSMutableArray alloc] init];
        // Initialise arrays to store which times have been seen previously, so that a total can be calculated.
        
        NSString *date = [[NSString alloc] init];
        NSString *prevDate = [[NSString alloc] init];
        
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
        
        int dateCounter = 0;
        
        for (int i = 0; i < [datesAndTimes count]; i++){
            
            prevDate = date;
            
            NSString *dt = [datesAndTimes objectAtIndex:i];
            NSArray *dtComp = [dt componentsSeparatedByString:@" "];
            NSString *time = [dtComp objectAtIndex:1];
            date = [dtComp objectAtIndex:0];
            
            [obj.titleArray addObject:time];
            [obj.titleArray2 addObject:time];
            
            [obj.valueArray addObject:[dtValues objectAtIndex:i]];
            [obj.valueArray2 addObject:[dtValues objectAtIndex:i]];
            
            if (![prevDate isEqualToString:date]){
                [obj.dateArray addObject:date];
                [obj.dateArray addObject:[NSString stringWithFormat:@"%d", dateCounter]];
            }
            dateCounter++;
        }
        
        [obj.dateArray addObject:@""];
        [obj.dateArray addObject:[NSString stringWithFormat:@"%d", dateCounter-1]];
        
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
        
        //        self.valueArray2 = [[NSMutableArray alloc] initWithObjects:
        //                            [NSNumber numberWithInt:1],
        //                            [NSNumber numberWithInt:2],
        //                            [NSNumber numberWithInt:5],
        //                            nil];
        
        int segmentCount = (int)[obj.valueArray count];
        
        for (int i = 0; i < segmentCount; i++){
            int odd = 4;
            int odd2 = 3;
            int even = 1;
            int even2 = 1;
            if (i%2 == 0){
                odd = 1;
                odd2 = 1;
                even = 4;
                even2 = 3;
            }
            [obj.colorArray addObject:[UIColor colorWithHue:((odd*i/segmentCount)%20)/20.0+0.28 saturation:(even*i%segmentCount+3)/10.0 brightness:91/100.0 alpha:1]];
            [obj.colorArray2 addObject:[UIColor colorWithHue:((odd2*i/segmentCount)%20)/20.0+0.075 saturation:(even2*i%segmentCount+3)/10.0 brightness:91/100.0 alpha:1]];
            
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    // When the user achknowledges the warning, the app segues to the mani menu.
    if([[alertView title] isEqualToString:@"Connection Warning!"]){
        [self performSegueWithIdentifier:@"segue.to.mainscreen" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
