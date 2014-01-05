//
//  PieChartView.h
//  Energi
//
//  Created by Scott Boyd on 25/10/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatedView.h"

@class PieChartView;

@protocol PieChartDelegate <NSObject>

@optional
- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per;
- (void)onCenterClick:(PieChartView *)PieChartView;
@end

@interface PieChartView : UIView <RotatedViewDelegate>

@property(nonatomic, assign) id<PieChartDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withValue:(NSMutableArray *)valueArr withColor:(NSMutableArray *)colorArr;
- (void)reloadChart;
- (void)setAmountText:(NSString *)text;
- (void)setTitleText:(NSString *)text;

@property (nonatomic,strong)RotatedView *rotatedView;
@property (nonatomic,strong) UIButton *centerView;
@property (nonatomic,strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *title;

@end
