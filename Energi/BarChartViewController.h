//
//  BarChartViewController.h
//  Energi
//
//  Created by Scott Boyd on 19/12/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECGraph.h"
#import "ECCommon.h"
#import "ECGraphPoint.h"
#import "ECGraphLine.h"
#import "ECGraphItem.h"
#import "DataClass.h"
#import "DisplayView.h"


@interface BarChartViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *IDlbl;
@property (nonatomic, strong) IBOutlet UIButton *changeUnitsButton;
@end