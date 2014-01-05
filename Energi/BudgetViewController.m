//
//  BudgetViewController.m
//  Energi
//
//  Created by Scott Boyd on 11/12/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "BudgetViewController.h"
#import "DataClass.h"

@implementation BudgetViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    DataClass *obj = [DataClass getInstance];
    if (obj.budget){
        self.mySlider.value = obj.budget;
        [self sliderChanged:self];
    }
    
	// Do any additional setup after loading the view.
}


-(IBAction)sliderChanged:(id)sender{
    float budgetValueFloat = self.mySlider.value;
    int budgetValue = (int)budgetValueFloat;
    DataClass *obj = [DataClass getInstance];
    obj.budget = budgetValue;
    NSString *result = [NSString stringWithFormat:@"£%i", budgetValue];
    self.budgetLabel.text = result;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"users.csv"];
    // Finds the csv file to store the budget to the username.
    
    NSString *lines = [NSString stringWithContentsOfFile:appFile encoding:1 error:NULL];
    
    NSArray *users = [lines componentsSeparatedByString:@"\n"];
    
    lines = @"";
    NSString *newuser = @"";
    
    for (int i = 0; i < [users count]; i++){
        NSArray *attributes = [[users objectAtIndex:i] componentsSeparatedByString:@" "];
        NSString *user = [attributes objectAtIndex:0];
        if ([obj.username isEqualToString:user]){
            NSString *budget = [NSString stringWithFormat:@" %i\n", budgetValue];
            if([attributes count] > 2){
                newuser = [[[[attributes objectAtIndex:0] stringByAppendingString:@" "] stringByAppendingString:[attributes objectAtIndex:1]] stringByAppendingString:budget];
            }else{
                newuser = [[users objectAtIndex:i] stringByAppendingString:budget];
            }
            
        }else{
            newuser = [[users objectAtIndex:i] stringByAppendingString:@"\n"];
        }
        lines = [lines stringByAppendingString:newuser];
    }
    
    [lines writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    // Write to .csv file.

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
