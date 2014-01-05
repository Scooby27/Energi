//
//  MenuViewController.m
//  Energi
//
//  Created by Scott Boyd on 13/11/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "MenuViewController.h"
#import "SettingsTableViewController.h"

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
    // Allows all orientations to be supported.
}
-(IBAction)unwindToMenu:(UIStoryboardSegue*)sender{
    
    UIViewController* sourceViewController = sender.sourceViewController;
    
    if ([sourceViewController isKindOfClass:[SettingsTableViewController class]]){
        NSLog(@"Tableeeeeeeeee");
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    // Return YES for supported orientations
}
@end
