//
//  BudgetViewController.h
//  Energi
//
//  Created by Scott Boyd on 11/12/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BudgetViewController : UIViewController


- (IBAction)sliderChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *mySlider;

@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;

@end
