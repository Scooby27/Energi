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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    DataClass *obj = [DataClass getInstance];
    self.IDlbl.text = [NSString stringWithFormat:@"ID: %@", obj.houseID];
    // Creates a label notifying the household that is currently logged in.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


@end
