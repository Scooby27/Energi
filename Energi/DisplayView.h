//
//  DisplayView.h
//  Energi
//
//  Created by Scott Boyd on 04/01/2014.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECGraph.h"
#import "DataClass.h"

@interface DisplayView : UIView <ECGraphDelegate>


@property (weak, nonatomic) IBOutlet UILabel *totalLbl;


@end
