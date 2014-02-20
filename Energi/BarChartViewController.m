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
    
    self.picker.delegate = self;
    // Shows the picker on the view.

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
    DataClass *obj = [DataClass getInstance];
    obj.barGraphChangeUnit = !obj.barGraphChangeUnit;
    // When the button is pressed, change the boolean variable to the opposite of its current value.
    
    [self performSegueWithIdentifier:@"segue.to.self" sender:self];
    // Reload the view to update values on bar graph.
}

- (IBAction)changeDate:(id)sender{
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
