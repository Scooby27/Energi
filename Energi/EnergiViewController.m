//
//  EnergiViewController.m
//  Energi
//
//  Created by Scott Boyd on 25/10/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "EnergiViewController.h"
#import "DataClass.h"

@implementation EnergiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    DataClass *obj = [DataClass getInstance];
    obj.budget = 55;
    obj.username = @"";
    // Clears any value each user.
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

- (IBAction)registerAlert:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register Details"
                                                      message:@"Please enter your desired username and password."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Register", nil];
    // Sets up registration alert.
    
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    // Creates text fields for the user to input their username and password.
    
    [alert show];
    // Show the alert.
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    // Get the title of the button pressed.
    
    if([[alertView title] isEqualToString:@"Registration Warning!"]){[self registerAlert:self];}
    
    if([title isEqualToString:@"Register"])
    {
        NSString *userInit = [alertView textFieldAtIndex:0].text;
        NSString *user = [userInit stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSString *password = [alertView textFieldAtIndex:1].text;
        NSUInteger hashValueInt = [password hash];
        NSString *hashValue = [NSString stringWithFormat:@" %lu\n", (unsigned long)hashValueInt];
        // Get the value of the username and the hashed value of the password.
        
        BOOL valid = YES;
        for (int i = 0; i < [user length]; i++){
            if([user characterAtIndex:i] == ' '){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Warning!" message:@"Username cannot contain any spaces." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                // Sets up warning alert.
                
                [alert show];
                // Show the alert.
                valid = NO;
                break;
            }
        }
        
        if (([user length] == 0) || hashValueInt == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Warning!" message:@"Cannot have any blank fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            // Sets up warning alert.
            
            [alert show];
            // Show the alert.
            valid = NO;
        }
        
        if(valid){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"users.csv"];
            // Creates or finds the csv file to store usernames and hashed passwords.
            
            
            NSString *oldLines = [NSString stringWithContentsOfFile:appFile encoding:1 error:NULL];
            NSString *newline = [user stringByAppendingString:hashValue];
            
            NSString *line = newline;
            
            if (oldLines){
                
                NSArray *combos = [oldLines componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
                // Returns an array where every element is a user and their attributes
                for (int i = 0; i < [combos count]; i++){
                    NSArray *attributes = [[combos objectAtIndex:i] componentsSeparatedByString:@" "];
        
                    if([user isEqualToString:[attributes objectAtIndex:0]]){
                        NSString *error = [NSString stringWithFormat:@"Username \"%@\" is already taken. Please try again.", user];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Warning!" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        // Sets up warning alert.
                        
                        [alert show];
                        // Show the alert.
                        valid = NO;
                        break;
                    }
                }

                line = [oldLines stringByAppendingString:newline];
            }
            
            if(valid){
                
                [line writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
                // Write to .csv file.
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Successful!" message:@"You are now logged in." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                // Sets up warning alert.
                
                [alert show];
                // Show the alert.
                
                self.textField.text = user;
                self.textField1.text = password;
                [self login:self];
                // Login with the new registered member.
                
            }
            
        }
        
    }
    
}

- (IBAction)login:(id)sender {
    
    DataClass *obj = [DataClass getInstance];
    // Used for global variables.
    
    [self.textField resignFirstResponder];
    [self.textField1 resignFirstResponder];
    // If login is actioned ensure all keyboards are resigned.
    
    self.userName = self.textField.text;
    // Set username as input text.
    
    self.password = self.textField1.text;
    // Set password as input text.
    
    NSString *usernameString = self.userName;
    // Create NSString object containing username.
    
    BOOL successfulLogin = NO;
    // Initialise login boolean.
    
    usernameString = [usernameString lowercaseString];
    // Username not case sensitive.
  
    NSUInteger passwordHashInt = [self.password hash];
    // Creates a hash value of the password for security.
    
    if ([usernameString length] != 0){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"users.csv"];
        // Finds the local .csv file containing registered users.
        
        NSString *fileString = [NSString stringWithContentsOfFile:appFile encoding:NSUTF8StringEncoding error:NULL];
        if (!fileString){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Warning!" message:@"There are no registered users. Please register before logging in." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            // Sets up warning alert.
            
            [alert show];
            // Show the alert.
        }else{
            NSArray *combos = [fileString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
            // Returns an array where every element contains the attributes of a user.
            for (int i = 0; i < [combos count]; i++){
                NSArray *attributes = [[combos objectAtIndex:i] componentsSeparatedByString:@" "];
                
                if([usernameString isEqualToString:[attributes objectAtIndex:0]]){
                    if(passwordHashInt == [[attributes objectAtIndex:1] longLongValue]){
                        successfulLogin = YES;
                        if ([attributes count] > 2){
                            obj.budget = (int)[[attributes objectAtIndex:2] longLongValue];
                        }
                        break;
                    }
                }
            }
            
            if (successfulLogin){
                
                obj.username = usernameString;
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
                UIViewController *vc = [mainSB instantiateViewControllerWithIdentifier:@"energiMenuView"];
                [self presentViewController:vc animated:YES completion:nil];
                // If correct login then continue to app.
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Warning!" message:@"Please enter a valid username and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                // Sets up warning alert.
                
                [alert show];
                // Show the alert.
            }
            
        }

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Warning!" message:@"One or more fields are blank. Please enter your login details." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        // Sets up warning alert.
        
        [alert show];
        // Show the alert.
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.textField){
        [self.textField1 becomeFirstResponder];
        // Move to password text field.
    }
        
    if (theTextField == self.textField1){
        [theTextField resignFirstResponder];
        [self login:self];
        // Automatically logs in when 'Go' is pressed.
    }
    return YES;
}


- (IBAction)tapResignFirstResponder:(id)sender{
    
    [self.textField resignFirstResponder];
    [self.textField1 resignFirstResponder];
    // Keyboard disappears if the user taps elsewhere on the screen.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    // Return YES for supported orientations
}

@end
