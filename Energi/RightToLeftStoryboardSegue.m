//
//  CustomStoryboardSegue.m
//  Energi
//
//  Created by Scott Boyd on 13/11/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "RightToLeftStoryboardSegue.h"
#import "DataClass.h"

@implementation RightToLeftStoryboardSegue

- (void)perform {
    
    UIViewController* source = (UIViewController *)self.sourceViewController;
    UIViewController* destination;
    
    NSString *sourcestr = [NSString stringWithFormat:@"%@", source];
    NSArray *components = [sourcestr componentsSeparatedByString:@" "];
    NSString *sourceviewname = [components objectAtIndex:0];
    // Variables used to define if the global variable needs to be used to return
    // to a previous view from settings.
    
    if ([sourceviewname isEqualToString:@"<SettingsTableViewController:"]){
        DataClass *obj = [DataClass getInstance];
        destination = obj.sourceview;
        // If in the settings view the destination is the original source view.
    }else{ destination = (UIViewController *)self.destinationViewController;}
        // Otherwise it is the destination view.
    
//    NSString *destinationstr = [NSString stringWithFormat:@"%@", destination];
//    components = [destinationstr componentsSeparatedByString:@" "];
//    NSString *destinationviewname = [components objectAtIndex:0];
//    // Variables used to determine the orientation of the destination view.
//    
//    if ([destinationviewname isEqualToString:@"<BarChartViewController:"]){
//        destination.shouldAutorotate;
//        
//    }

    CGRect sourceFrame = source.view.frame;
    sourceFrame.origin.x = -sourceFrame.size.width;
    
    CGRect destFrame = destination.view.frame;
    destFrame.origin.x = destination.view.frame.size.width;
    destination.view.frame = destFrame;
    
    destFrame.origin.x = 0;
    
    [source.view.superview addSubview:destination.view];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         source.view.frame = sourceFrame;
                         destination.view.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         UIWindow *window = source.view.window;
                         [window setRootViewController:destination];
                     }];
}

@end
