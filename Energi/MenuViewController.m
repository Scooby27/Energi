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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
