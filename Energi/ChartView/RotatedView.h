//
//  RotatedView.h
//  Energi
//
//  Created by Scott Boyd on 25/10/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "RenderView.h"

@class RotatedView;
@protocol RotatedViewDelegate <NSObject>
@optional
- (void)selectedFinish:(RotatedView *)rotatedView index:(NSInteger)index percent:(float)per title:(NSString *)title;
@end

@interface RotatedView : UIView<RenderViewDataSource,RenderViewtDelegate> {
    float               mZeroAngle;
    NSMutableArray     *mValueArray;
    NSMutableArray     *mColorArray;
    NSMutableArray     *mTitleArray;
    NSMutableArray     *mThetaArray;
    
    BOOL                isAnimating;
    BOOL                isTapStopped;
    BOOL                isAutoRotation;
    float               mAbsoluteTheta;
    float               mRelativeTheta;
    UITextView         *mInfoTextView;
    
    float               mDragSpeed;
    NSDate             *mDragBeforeDate;
    float               mDragBeforeTheta;
    NSTimer            *mDecelerateTimer;
}
@property(nonatomic, assign) id<RotatedViewDelegate> delegate;
@property (nonatomic)float fracValue;
@property (nonatomic)         float           mZeroAngle;
@property (nonatomic)         BOOL            isAutoRotation;
@property (nonatomic, retain) NSMutableArray *mValueArray;
@property (nonatomic, retain) NSMutableArray *mColorArray;
@property (nonatomic, retain) NSMutableArray *mTitleArray;
@property (nonatomic, retain) UITextView     *mInfoTextView;

- (void)startedAnimate;
- (void)reloadPie;
@end
