//
//  RotatedView.m
//  Energi
//
//  Created by Scott Boyd on 25/10/2013.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//


#import "RotatedView.h"
#include <math.h>

#define K_EPSINON        (1e-127)
#define IS_ZERO_FLOAT(X) (X < K_EPSINON && X > -K_EPSINON)

#define K_FRICTION              6.0f
#define K_MAX_SPEED             12.0f
#define K_POINTER_ANGLE         (M_PI / 2)

@interface RotatedView()
@property (nonatomic,assign) NSInteger selectedIndex;
- (void)timerStop;
- (void)tapStopped;
- (void)decelerate;
@property (strong, nonatomic) RenderView *pieChart;
@property (nonatomic, assign) BOOL canLayerOpen;
@end

@implementation RotatedView

@synthesize mZeroAngle;
@synthesize mValueArray;
@synthesize mColorArray;
@synthesize mTitleArray;
@synthesize mInfoTextView;
@synthesize isAutoRotation;
@synthesize fracValue;
@synthesize pieChart;
@synthesize delegate;

#pragma mark -
#pragma mark Initialize

- (void)dealloc {
    [UIView setAnimationDelegate:nil];
    mValueArray = nil;
    mColorArray = nil;
    mTitleArray = nil;
    mThetaArray = nil;
    mInfoTextView = nil;
    mDragBeforeDate = nil;
    
    [mDecelerateTimer invalidate];
    mDecelerateTimer = nil;
    
    self.pieChart.delegate = nil;
    self.pieChart = nil;
    
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        mRelativeTheta = 0.0;
        isAnimating = NO;
        isTapStopped = NO;
        
        self.pieChart = [[RenderView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.pieChart.dataSource = self;
        [self.pieChart setStartPieAngle:0];
        [self.pieChart setAnimationSpeed:1.0];
        [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:15]];
        [self.pieChart setPieCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
        [self.pieChart setUserInteractionEnabled:NO];
        self.pieChart.delegate = self;
        [self addSubview:self.pieChart];
    }
    return self;
}

- (void)reloadPie
{
    isAutoRotation = YES;
    [self.pieChart reloadData];
}

- (void)drawRect:(CGRect)rect {
    
    int wedges = (int)[mValueArray count];
    if (wedges > [mColorArray count]) {
        NSLog(@"Number of colors is not enough: please add %i kinds of colors.",wedges - (int)[mColorArray count]);
        for (int i = (int)[mColorArray count]; i < wedges; ++i) {
            [mColorArray addObject:[UIColor whiteColor]];
        }
    }
    
    mThetaArray = [[NSMutableArray alloc] initWithCapacity:wedges];
    
    float sum = 0.0;
    for (int i = 0; i < wedges; ++i) {
        sum += [[mValueArray objectAtIndex:i] floatValue];
    }
    float frac = 2.0 * M_PI / sum;
    self.fracValue = frac;
    
    float startAngle = mZeroAngle;
    float endAngle   = mZeroAngle;
    for (int i = 0; i < wedges; ++i) {
        startAngle = endAngle;
        endAngle  += [[mValueArray objectAtIndex:i] floatValue] * frac;
        [mThetaArray addObject:[NSNumber numberWithFloat:endAngle]];
    }
}


- (void)startedAnimate
{
    [self performSelector:@selector(delayAnimate) withObject:nil afterDelay:0.0f];
}

#pragma mark -
#pragma mark handle rotation angle
- (float)thetaForX:(float)x andY:(float)y {
    if (IS_ZERO_FLOAT(y)) {
        if (x < 0) {
            return M_PI;
        } else {
            return 0;
        }
    }
    
    float theta = atan(y / x);
    if (x < 0 && y > 0) {
        theta = M_PI + theta;
    } else if (x < 0 && y < 0) {
        theta = M_PI + theta;
    } else if (x > 0 && y < 0) {
        theta = 2 * M_PI + theta;
    }
    return theta;
}

- (float)rotationThetaForNewTheta:(float)newTheta {
    float rotationTheta;
    if (mRelativeTheta > (3 * M_PI / 2) && (newTheta < M_PI / 2)) {
        rotationTheta = newTheta + (2 * M_PI - mRelativeTheta);
    } else {
        rotationTheta = newTheta - mRelativeTheta;
    }
    return rotationTheta;
}

- (float)thetaForTouch:(UITouch *)touch onView:view {
    CGPoint location = [touch locationInView:view];
    float xOffset    = self.bounds.size.width / 2;
    float yOffset    = self.bounds.size.height / 2;
    float centeredX  = location.x - xOffset;
    float centeredY  = location.y - yOffset;
    
    return [self thetaForX:centeredX andY:centeredY];
}

#pragma mark -
#pragma mark Private & handle rotation
- (void)timerStop {
    [mDecelerateTimer invalidate];
    mDecelerateTimer = nil;
    mDragSpeed = 0;
    isAnimating = NO;
    
    [self performSelector:@selector(delayAnimate) withObject:nil afterDelay:0.0f];
    return;
}

- (void)delayAnimate
{
    double tan2 = atan2(self.transform.b, self.transform.a);
    //    CGFloat angle = [(NSNumber *)[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    float curTheta = M_PI/2 - tan2;
    curTheta = curTheta > 0?curTheta:M_PI*2+curTheta;
    int selIndex = 0;
    for (;selIndex < [mThetaArray count]; selIndex++) {
        if (curTheta < [[mThetaArray objectAtIndex:selIndex] floatValue]) {
            break;
        }
    }
    
    float calTheta = [[mThetaArray objectAtIndex:selIndex] floatValue] - curTheta;
    float fanTheta = [[mValueArray objectAtIndex:selIndex] floatValue] * self.fracValue;
    float rotateTheta = fanTheta/2 - calTheta;
    
    [UIView animateWithDuration:0.42 animations:^{
        self.transform = CGAffineTransformRotate(self.transform,rotateTheta);
    } completion:^(BOOL finished) {
        //
        [self outPie];
    }];
    [self delayAnimateStop:selIndex];
    
}

- (void)outPie
{
    [self.pieChart pieSelected:self.selectedIndex];
    self.canLayerOpen = YES;
}

- (void)delayAnimateStop:(NSInteger)index
{
    float sum = 0.0;
    for (int i = 0; i < [mValueArray count]; ++i) {
        sum += [[mValueArray objectAtIndex:i] floatValue];
    }
    float percent = [[mValueArray objectAtIndex:index] floatValue]/sum;
    NSString *title = [mTitleArray objectAtIndex:index];
    self.selectedIndex = index;
    if ([self.delegate respondsToSelector:@selector(selectedFinish:index:percent:title:)]) {
        [self.delegate selectedFinish:self index:index percent:percent title:title];
    }
}

- (void)animationDidStop:(NSString*)str finished:(NSNumber*)flag context:(void*)context {
    isAutoRotation = NO;
    [self delayAnimate];
}

- (int)touchIndex
{
    int index;
    
    for (index = 0; index < [mThetaArray count]; index++) {
        if (mRelativeTheta < [[mThetaArray objectAtIndex:index] floatValue]) {
            break;
        }
    }
    
    return index;
}

- (void)tapStopped {
    int tapAreaIndex = [self touchIndex];
    
    if (tapAreaIndex == 0) {
        mRelativeTheta = [[mThetaArray objectAtIndex:0] floatValue] / 2;
    } else {
        mRelativeTheta = [[mThetaArray objectAtIndex:tapAreaIndex] floatValue]
        - (([[mThetaArray objectAtIndex:tapAreaIndex] floatValue]
            - [[mThetaArray objectAtIndex:tapAreaIndex - 1] floatValue]) / 2);
    }
    if (tapAreaIndex != self.selectedIndex) {
        if (self.canLayerOpen) {
            [self.pieChart pieSelected:self.selectedIndex];
            self.canLayerOpen = NO;
        }
        isAutoRotation = YES;
        [UIView beginAnimations:@"tap stopped" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        self.transform = CGAffineTransformMakeRotation([self rotationThetaForNewTheta:K_POINTER_ANGLE]);
        [UIView commitAnimations];
    }
    
    return;
}

- (void)decelerate {
    if (mDragSpeed > 0) {
        mDragSpeed -= (K_FRICTION / 100);
        
        if (mDragSpeed < 0.01) {
            [self timerStop];
        }
        
        mAbsoluteTheta += (mDragSpeed / 100);
        if ((M_PI * 2) < mAbsoluteTheta) {
            mAbsoluteTheta -= (M_PI * 2);
        }
    } else if (mDragSpeed < 0){
        mDragSpeed += (K_FRICTION /100);
        if (mDragSpeed > -0.01) {
            [self timerStop];
        }
        
        mAbsoluteTheta += (mDragSpeed / 100);
        if (0 > mAbsoluteTheta) {
            mAbsoluteTheta = (M_PI * 2) + mAbsoluteTheta;
        }
    }
    
    isAnimating = YES;
    [UIView beginAnimations:@"pie rotation" context:nil];
    [UIView setAnimationDuration:0.01];
    self.transform = CGAffineTransformMakeRotation([self rotationThetaForNewTheta:mAbsoluteTheta]);
    
    [UIView commitAnimations];
    
    return;
}

#pragma mark -
#pragma mark Responder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (isAutoRotation) {
        return;
    }
    
    isTapStopped = IS_ZERO_FLOAT(mDragSpeed);
    
    if ([mDecelerateTimer isValid]) {
        [mDecelerateTimer invalidate];
        mDecelerateTimer = nil;
        mDragSpeed = 0;
        isAnimating = NO;
    }
    
    UITouch *touch   = [touches anyObject];
    mAbsoluteTheta   = [self thetaForTouch:touch onView:self.superview];
    mRelativeTheta   = [self thetaForTouch:touch onView:self];
    mDragBeforeDate  = [NSDate date];
    mDragBeforeTheta = 0.0f;
    
    return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (isAutoRotation) {
        return;
    }
    
    if (self.canLayerOpen) {
        [self.pieChart pieSelected:self.selectedIndex];
        self.canLayerOpen = NO;
    }
    
    isAnimating = YES;
    UITouch *touch = [touches anyObject];
    
    mAbsoluteTheta = [self thetaForTouch:touch onView:self.superview];
    
    NSTimeInterval dragInterval = [mDragBeforeDate timeIntervalSinceNow];
    
    if (fabsf(mAbsoluteTheta - mDragBeforeTheta) > M_PI) {
        if (mAbsoluteTheta > mDragBeforeTheta) {
            mDragSpeed = (mAbsoluteTheta - (mDragBeforeTheta + 2 * M_PI)) / fabs(dragInterval);
        } else {
            mDragSpeed = ((mAbsoluteTheta + 2 * M_PI) - mDragBeforeTheta) / fabs(dragInterval);
        }
    } else {
        mDragSpeed = (mAbsoluteTheta - mDragBeforeTheta) / fabs(dragInterval);
    }
    [mInfoTextView setText:
     [NSString stringWithFormat:
      @"relative theta   = %.2f\nabsolute theta   = %.2f\nrotation theta   = %.2f\nspeed = %f",
      mRelativeTheta, mAbsoluteTheta, [self rotationThetaForNewTheta:mAbsoluteTheta], mDragSpeed]];
    [UIView beginAnimations:@"pie rotation" context:nil];
    [UIView setAnimationDuration:1];
    self.transform = CGAffineTransformMakeRotation([self rotationThetaForNewTheta:mAbsoluteTheta]);
    
    [UIView commitAnimations];
    isAnimating = NO;
    
    mDragBeforeTheta = mAbsoluteTheta;
    mDragBeforeDate = [NSDate date];
    
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isAutoRotation) {
        return;
    }
    
    if (IS_ZERO_FLOAT(mDragSpeed)) {
        if (isTapStopped) {
            [self tapStopped];
            return;
        } else {
            [self delayAnimate];
            return;
        }
    } else if ((fabsf(mDragSpeed) > K_MAX_SPEED)) {
        mDragSpeed = (mDragSpeed > 0) ? K_MAX_SPEED : -K_MAX_SPEED;
    }
    NSTimer * timer = [NSTimer timerWithTimeInterval:0.01
											  target:self
											selector:@selector(decelerate)
											userInfo:nil
											 repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    mDecelerateTimer = timer;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
#pragma -mark xypieSource
- (NSUInteger)numberOfSlicesInPieChart:(RenderView *)pieChart
{
    return [mValueArray count];
}

- (CGFloat)pieChart:(RenderView *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[mValueArray objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(RenderView *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [mColorArray objectAtIndex:index];
}

- (void)animateFinish:(RenderView *)pieChart
{
    isAutoRotation = NO;
    [self startedAnimate];
}
@end
