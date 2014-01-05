//
//  MenuViewController.h
//  Energi
//
//  Created by Scott Boyd on 13/11/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MenuViewController : UIViewController

-(IBAction)toSettings;

-(IBAction)unwindToMenu:(UIStoryboardSegue*)sender;

@end
