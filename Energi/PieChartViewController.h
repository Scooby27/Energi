//
//  PieChartViewController.h
//  Energi
//
//  Created by Scott Boyd on 18/12/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PieChartView.h"
#import "LeftToRightStoryboardSegue.h"
#import "MenuViewController.h"
#import "DataClass.h"

@interface PieChartViewController : UIViewController <PieChartDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *valueArray2;
@property (nonatomic,strong) NSMutableArray *colorArray2;
@property (nonatomic,strong) NSMutableArray *titleArray2;
@property (nonatomic,strong) PieChartView *pieChartView;
@property (nonatomic,strong) UIView *pieContainer;
@property (nonatomic)BOOL inOut;
@property (nonatomic,strong) UILabel *selLabel;
@property (nonatomic,strong) IBOutlet UILabel *displayRangeLbl;
@property (weak, nonatomic) IBOutlet UILabel *IDlbl;
@property (weak, nonatomic) IBOutlet UILabel *totalLbl;
@property (nonatomic, strong) IBOutlet UIButton *changeUnitsButton;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UIWebView *requestWebView;

@end
