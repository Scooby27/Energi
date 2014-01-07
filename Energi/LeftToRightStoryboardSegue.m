//
//  LeftToRightStoryboardSegue.m
//  Energi
//
//  Created by Scott Boyd on 13/11/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "LeftToRightStoryboardSegue.h"
#import "DataClass.h"

@implementation LeftToRightStoryboardSegue

- (void)perform {
    DataClass *obj = [DataClass getInstance];
    
    UIViewController* source = (UIViewController *)self.sourceViewController;
    UIViewController* destination = (UIViewController *)self.destinationViewController;
    
    obj.sourceview = source;
    
    CGRect sourceFrame = source.view.frame;
    sourceFrame.origin.x = sourceFrame.size.width;
    
    CGRect destFrame = destination.view.frame;
    destFrame.origin.x = -destination.view.frame.size.width;
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
