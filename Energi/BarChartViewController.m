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
    
    if (obj.barGraphChangeUnit){
        [self.changeUnitsButton setTitle:@"Cost" forState:UIControlStateNormal];
    }else{
        [self.changeUnitsButton setTitle:@"Energy" forState:UIControlStateNormal];
    }
    // Change text depending on current setting.
    
}

- (IBAction)changeUnits:(id)sender{
    DataClass *obj = [DataClass getInstance];
    obj.barGraphChangeUnit = !obj.barGraphChangeUnit;
    // When the button is pressed, change the boolean variable to the opposite of its current value.
    
    [self performSegueWithIdentifier:@"segue.to.self" sender:self];
    // Reload the view to update values on bar graph.
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
