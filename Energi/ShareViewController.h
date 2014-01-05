//
//  ShareViewController.h
//  Energi
//
//  Created by Scott Boyd on 18/12/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ShareViewController : UIViewController <FBLoginViewDelegate>

- (IBAction)facebook:(id)sender;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
