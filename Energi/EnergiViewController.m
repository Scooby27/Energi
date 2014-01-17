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
    obj.budget = 55;
    obj.houseID = @"";
    obj.sourceview = [UIViewController init];
    obj.colorArray = [NSMutableArray init];
    obj.valueArray = [NSMutableArray init];
    obj.titleArray = [NSMutableArray init];
    
    // Clears any value each user.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAlert:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register Details"
                                                      message:@"Please enter your House ID and password. Both can be found on your Smart Meter."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Register", nil];
    // Sets up registration alert.
    
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    // Creates text fields for the user to input their username and password.
    
    [alert textFieldAtIndex:0].placeholder = @"House ID";
    
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
        NSString *houseIDInit = [alertView textFieldAtIndex:0].text;
        NSString *houseID = [houseIDInit stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSString *password = [alertView textFieldAtIndex:1].text;
        NSUInteger hashValueInt = [password hash];
        NSString *hashValue = [NSString stringWithFormat:@" %lu\n", (unsigned long)hashValueInt];
        // Get the value of the username and the hashed value of the password.
        
        BOOL valid = YES;
        for (int i = 0; i < [houseID length]; i++){
            if([houseID characterAtIndex:i] == ' '){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Warning!" message:@"House ID cannot contain any spaces." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                // Sets up warning alert.
                
                [alert show];
                // Show the alert.
                valid = NO;
                break;
            }
        }
        
        if (([houseID length] == 0) || hashValueInt == 0){
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
            NSString *urlString = @"http://textuploader.com/1r2w/raw";
            // Retrieves the list of house IDs from the server.
            NSURL *url = [NSURL URLWithString:urlString];
            
            NSString *oldLines = [NSString stringWithContentsOfFile:appFile encoding:1 error:NULL];
            
            NSString *houseIDString = [NSString stringWithContentsOfURL:url encoding:1 error:NULL];

            NSString *newline = [houseID stringByAppendingString:hashValue];
            
            NSString *line = newline;
            
            if (oldLines){
                
                NSArray *combos = [oldLines componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
                // Returns an array where every element is a user and their attributes
                for (int i = 0; i < [combos count]; i++){
                    NSArray *attributes = [[combos objectAtIndex:i] componentsSeparatedByString:@" "];
        
                    if([houseID isEqualToString:[attributes objectAtIndex:0]]){
                        NSString *error = [NSString stringWithFormat:@"House ID \"%@\" has already registered. Please try again.", houseID];
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
                
                NSArray *houseIDs = [houseIDString componentsSeparatedByString:@"\n"];
                // Returns an array where each element is a house ID.
                
                valid = false;
                // Reset the valid flag to false.
                
                for (int i = 1; i < [houseIDs count]-1; i++){
                    NSString *nextID = [[houseIDs objectAtIndex:i] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                    if ([houseID longLongValue] ==  [nextID longLongValue]){
                        valid = true;
                        // Valid only if the house ID entered is registered as a Smart Meter enabled household.
                        break;
                    }
                }
                
                if (valid){
                    
                    [line writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
                    // Write to .csv file.
                    
                    NSString *successMessage = [NSString stringWithFormat:@"You are now logged in with House ID: %@.", houseID];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Successful!" message:successMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    // Sets up warning alert.
                    
                    [alert show];
                    // Show the alert.
                    
                    self.textField.text = houseID;
                    self.textField1.text = password;
                    [self login:self];
                    // Login with the new registered member.
                }else{
                    NSString *error = [NSString stringWithFormat:@"%@ is not a valid Smart Meter registered House ID. Please try again.", houseID];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Warning!" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    // Sets up warning alert.
                    
                    [alert show];
                    // Show the alert.
                }
                
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
    
    self.houseID = self.textField.text;
    // Set username as input text.
    
    self.password = self.textField1.text;
    // Set password as input text.
    
    NSString *houseIDString = self.houseID;
    // Create NSString object containing username.
    
    BOOL successfulLogin = NO;
    // Initialise login boolean.
    
    houseIDString = [houseIDString lowercaseString];
    // Username not case sensitive.
  
    NSUInteger passwordHashInt = [self.password hash];
    // Creates a hash value of the password for security.
    
    if ([houseIDString length] != 0){
        
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
                
                if([houseIDString isEqualToString:[attributes objectAtIndex:0]]){
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
                
                obj.houseID = houseIDString;
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
                UIViewController *vc = [mainSB instantiateViewControllerWithIdentifier:@"energiMenuView"];
                [self presentViewController:vc animated:YES completion:nil];
                // If correct login then continue to app.
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Warning!" message:@"Please enter a valid House ID and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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

- (IBAction)retrieveData:(id)sender{
    
    NSString *getDataURL = @"https://raw2.github.com/Scooby27/Energi/master/Server/json.html";
   // NSString *getDataURL = @"http://conkave.com/iosdemos/json.php";
    NSURL *url = [NSURL URLWithString:getDataURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
   
    
    _json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    _homes = [[NSMutableArray alloc] init];
    NSLog(@"%lu, %lu", (unsigned long)[_json count], (unsigned long)_json.count);
    
    for(int i = 0; i < [_json count]; i++){
        
        NSString *homeid = [[_json objectAtIndex:i]objectForKey:@"homeid"];
        NSString *type = [[_json objectAtIndex:i]objectForKey:@"type"];
        NSString *location = [[_json objectAtIndex:i]objectForKey:@"location"];
        NSString *partof = [[_json objectAtIndex:i]objectForKey:@"partof"];
        NSString *detail = [[_json objectAtIndex:i]objectForKey:@"detail"];
        
        NSLog(@"homeid:%@\ntype:%@\nlocation:%@\npartof:%@\ndetail:%@", homeid, type, location, partof, detail);
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    // Return YES for supported orientations
}

@end
