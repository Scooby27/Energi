//
//  EnergiViewController.h
//  Energi
//
//  Created by Scott Boyd on 25/10/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface EnergiViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

- (IBAction)registerAlert:(id)sender;

- (IBAction)login:(id)sender;

- (IBAction)tapResignFirstResponder:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UITextField *textField1;

@property (copy, nonatomic) NSString *userName;

@property (copy, nonatomic) NSString *password;

@end