//
//  ECGraph.m
//  Energi
//
//  Created by Scott Boyd on 04/01/2014.
//  Copyright (c) 2013 Scott Boyd. All rights reserved.
//

#import "ECGraph.h"
#import <time.h>
#import <mach/mach_time.h>

#define XAXIS_OFFSET 30
#define YAXIS_OFFSET 30

#define PORTRAIT_SCREEN_WIDTH 320
#define PORTRAIT_SCREEN_HEIGHT 480
#define LANDSCAPE_SCREEN_WIDTH 480
#define LANDSCAPE_SCREEN_HEIGHT 320

#define XSPACEING 50
#define YSPACEING 30

//use for date and time
#define XDISPLAYSTR_MAX_COUNT 5
#define YDISPLAYSTR_MAX_COUNT 5
//use for number
#define YSTEPS_COUNT 5

//Histogram
#define XINSET 10

static inline double radians(double degrees){
	return degrees * M_PI/180;
}

@interface ECGraph(Private)
/*
 Line Style*/
-(void)drawDashedLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint length:(float)length distance:(float)distance withColor:(UIColor *)color;
/*
 Point Style*/
-(void)drawCircleAtPoint:(CGPoint)center withDiameter:(float)diameter fillColor:(UIColor *)fillColor stockeColor:(UIColor *)stockeColor;
-(void)drawTriangleAtPoint:(CGPoint)center withDiameter:(float)diameter fillColor:(UIColor *)fillColor stockeColor:(UIColor *)stockeColor rotate:(float)angle;
-(void)drawSquareAtPoint:(CGPoint)center withDiameter:(float)diameter fillColor:(UIColor *)fillColor stockeColor:(UIColor *)stockeColor rotate:(float)angle;
/*
 Draw Lines*/
-(void)drawLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint lineWidth:(int)lineWidth color:(UIColor *)color;
-(void)drawXLineAtPoint:(CGPoint)point lineWidth:(int)lineWidth color:(UIColor *)color highlighted:(BOOL)highlighted;
-(void)drawYLineAtPoint:(CGPoint)point lineWidth:(int)lineWidth color:(UIColor *)color highlighted:(BOOL)highlighted;
/*
 Draw Words*/
-(void)drawWords:(NSString *)words AtPoint:(CGPoint)point color:(UIColor *)color;
-(void)drawXYAxisTitleWithColor:(UIColor *)color;
/*
 Get Duration Of Days Or Hours*/
-(int)getDaysFrom:(NSDate *)beiginDate To:(NSDate *)endDate;
-(int)getHoursFrom:(NSDate *)beiginDate To:(NSDate *)endDate;
-(int)getXDaysFromLines:(NSArray *)lines minDate:(NSDate *)minDate;
-(int)getXHoursFromLines:(NSArray *)lines;

-(UIColor *)getRandomColor;
@end

@implementation ECGraph(Private)

-(void)drawLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint lineWidth:(int)lineWidth color:(UIColor *)color
{
	CGContextBeginPath(_context);
	CGContextSetLineWidth(_context, lineWidth);
	CGContextMoveToPoint(_context, startPoint.x, startPoint.y);
	CGContextAddLineToPoint(_context, endPoint.x, endPoint.y);
	CGContextClosePath(_context);
	[color setStroke];
	CGContextStrokePath(_context);
}

-(void)drawXLineAtPoint:(CGPoint)point lineWidth:(int)lineWidth color:(UIColor *)color highlighted:(BOOL)highlighted
{
	CGContextBeginPath(_context);
	CGContextSetLineWidth(_context, lineWidth);
	if (highlighted) {
		CGContextMoveToPoint(_context, point.x, point.y+5);
	}
	else {
		CGContextMoveToPoint(_context, point.x, point.y+1);   //correct the x-axis point
	}
	CGContextAddLineToPoint(_context, point.x, point.y-5);
	CGContextClosePath(_context);
	[color setStroke];
	CGContextStrokePath(_context);
}

-(void)drawYLineAtPoint:(CGPoint)point lineWidth:(int)lineWidth color:(UIColor *)color highlighted:(BOOL)highlighted
{
	CGContextBeginPath(_context);
	CGContextSetLineWidth(_context, lineWidth);
	if (highlighted) {
		CGContextMoveToPoint(_context, point.x-5, point.y);
	}
	else {
		CGContextMoveToPoint(_context, point.x, point.y);	
	}
	CGContextAddLineToPoint(_context, point.x+5, point.y);
	CGContextClosePath(_context);
	[color setStroke];
	CGContextStrokePath(_context);
}

- (void)drawDashedLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint length:(float)length distance:(float)distance withColor:(UIColor *)color
{
	float lineLength = sqrt(pow((endPoint.y - startPoint.y),2) + pow((endPoint.x - startPoint.x),2));
	float sinValue =  (float)(endPoint.x - startPoint.x)/lineLength;		//get sin
	float cosValue = (float)(endPoint.y - startPoint.y)/lineLength;		//get cos
	float lengthAdd = 0.0;
	int tempX;
	int tempY;
	CGPoint tempStart = startPoint;
	while(lengthAdd + length < lineLength)
	{
		lengthAdd += length;
		tempX = startPoint.x + sinValue * lengthAdd;
		tempY = startPoint.y + cosValue * lengthAdd;
		CGContextBeginPath(_context);
		CGContextMoveToPoint(_context, tempStart.x, tempStart.y);
		CGContextAddLineToPoint(_context, tempX, tempY);
		CGContextClosePath(_context);
		[color setStroke];
		CGContextStrokePath(_context);
		lengthAdd += distance;
		tempX = startPoint.x + sinValue * lengthAdd;
		tempY = startPoint.y + cosValue * lengthAdd;
		tempStart = CGPointMake(tempX,tempY);
	}
	
	CGContextBeginPath(_context);
	CGContextMoveToPoint(_context, tempStart.x, tempStart.y);
	CGContextAddLineToPoint(_context, endPoint.x, endPoint.y);
	CGContextClosePath(_context);
	[color setStroke];
	CGContextStrokePath(_context);
}

-(void)drawCircleAtPoint:(CGPoint)center withDiameter:(float)diameter fillColor:(UIColor *)fillColor stockeColor:(UIColor *)stockeColor;
{	
	float radius = diameter * 0.5;
	CGRect oval = {center.x - radius,center.y - radius,diameter,diameter};
	[fillColor setFill];
	CGContextAddEllipseInRect(_context, oval);
	CGContextFillPath(_context);
	CGContextAddArc(_context,center.x,center.y,radius,0,2*M_PI,1);
	[stockeColor setStroke];
	CGContextStrokePath(_context);
}

- (void)drawTriangleAtPoint:(CGPoint)center withDiameter:(float)diameter fillColor:(UIColor *)fillColor stockeColor:(UIColor *)stockeColor rotate:(float)angle
{
	int offsetX = cos(radians(30))*diameter;
	int offsetY = sin(radians(30))*diameter;
	
	float point1X = center.x - offsetX;
	float point1Y = center.y + offsetY;
	
	float point2X = center.x;
	float point2Y = center.y - diameter;
	
	float point3X = center.x + offsetX;
	float point3Y = center.y + offsetY;
	
	CGContextBeginPath(_context);
	CGContextMoveToPoint(_context, point1X,point1Y);
	CGContextAddLineToPoint(_context, point2X, point2Y);
	CGContextAddLineToPoint(_context, point3X, point3Y);
	CGContextClosePath(_context);
	[fillColor setFill];
	[stockeColor setStroke];
	CGContextDrawPath(_context, kCGPathFillStroke);
}

-(void)drawSquareAtPoint:(CGPoint)center withDiameter:(float)diameter fillColor:(UIColor *)fillColor stockeColor:(UIColor *)stockeColor rotate:(float)angle
{
	float length = sqrt(pow(diameter, 2)/2);
	CGRect rect = CGRectMake(center.x - length/2, center.y - length/2, length, length);
	[fillColor setFill];
	[stockeColor setStroke];
	CGContextAddRect(_context,rect);
	CGContextDrawPath(_context, kCGPathFillStroke);
}


-(void)drawWords:(NSString *)words AtPoint:(CGPoint)point color:(UIColor *)color 
{
	[color set];
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10]};
	[words drawAtPoint:point withAttributes:textAttributes];
}

-(int)getDaysFrom:(NSDate *)beiginDate To:(NSDate *)endDate
{
	NSDate *fromDate = [ECCommon dRemoveTimeOfD:beiginDate];
	NSDate *toDate = [ECCommon dRemoveTimeOfD:endDate];
	
	//get the remaining days
	NSCalendar *dateCalendar = [NSCalendar currentCalendar];
	
	unsigned int unitFlags = NSDayCalendarUnit;
	
	NSDateComponents *comps = [dateCalendar components:unitFlags fromDate:fromDate toDate:toDate options:0];
	
	int days = (int)[comps day] + 1;
	return days;
}

-(int)getHoursFrom:(NSDate *)beiginDate To:(NSDate *)endDate
{
	
	//get the remaining days
	NSCalendar *dateCalendar = [NSCalendar currentCalendar];
	
	unsigned int unitFlags = NSHourCalendarUnit;
	
	NSDateComponents *comps = [dateCalendar components:unitFlags fromDate:beiginDate toDate:endDate options:0];
	
	int hours = (int)[comps hour] + 1;
	return hours;
}

-(void)drawXYAxisTitleWithColor:(UIColor *)color
{
	[color set];
	UILabel *lb_xaxisTitle = [[UILabel alloc] initWithFrame:CGRectMake(_xaxisStart.x, _xaxisStart.y + 50, _xaxisLength, 30)];
	lb_xaxisTitle.text = _xaxisTitle;
	lb_xaxisTitle.textAlignment = NSTextAlignmentCenter;
	lb_xaxisTitle.backgroundColor = [UIColor clearColor];
	lb_xaxisTitle.font = [UIFont boldSystemFontOfSize:13];
	[ECCAST(UIView,_delegate) addSubview:lb_xaxisTitle];
	
	UILabel *lb_yaxisTitle = [[UILabel alloc] initWithFrame:CGRectMake(_xaxisStart.x - _yaxisLength/2 - 35, _yaxisEnd.y + _yaxisLength/2 , _yaxisLength, 18)];
	lb_yaxisTitle.text = _yaxisTitle;
	lb_yaxisTitle.textAlignment = NSTextAlignmentCenter;
	lb_yaxisTitle.backgroundColor = [UIColor clearColor];
	lb_yaxisTitle.font = [UIFont boldSystemFontOfSize:13];
	lb_yaxisTitle.transform = CGAffineTransformMakeRotation(-1.57);
	[ECCAST(UIView,_delegate) addSubview:lb_yaxisTitle];
	
	UILabel *lb_graphicTitle = [[UILabel alloc] initWithFrame:CGRectMake(_xaxisStart.x , _yaxisEnd.y - 20  , _xaxisLength, 20)];
	lb_graphicTitle.text = _graphicTitle;
	lb_graphicTitle.textAlignment = NSTextAlignmentCenter;
	lb_graphicTitle.backgroundColor = [UIColor clearColor];
	lb_graphicTitle.font = [UIFont boldSystemFontOfSize:13];
	[ECCAST(UIView,_delegate) addSubview:lb_graphicTitle];
}

-(int)getXDaysFromLines:(NSArray *)lines minDate:(NSDate*)minDate;
{
	NSDate *max = [ECCommon dOfS:@"1970-1-1 12:00:00" withFormat:kDEFAULT_DATE_TIME_FORMAT];
	NSDate *min = [NSDate date]; 
	for (int i = 0; i < [lines count]; ++i)
	{
		ECGraphLine *line = [lines objectAtIndex:i];
		NSArray *points = line.points;
		for (int j = 0; j < [points count]; ++j)
		{
			ECGraphPoint *graphicPoint = [points objectAtIndex:j];
			if ([graphicPoint.xDateValue compare:max] == NSOrderedDescending) 
			{
				max = graphicPoint.xDateValue;
			}
			
			if ([graphicPoint.xDateValue compare:min] == NSOrderedAscending)
			{
				min = graphicPoint.xDateValue;
			}
		}
	}
	int durationDays = [self getDaysFrom:min To:max];
	minDate = min;
	return durationDays;
}

-(int)getXHoursFromLines:(NSArray *)lines
{
	NSDate *max = [ECCommon dOfS:@"1970-1-1 12:00:00" withFormat:kDEFAULT_DATE_TIME_FORMAT];
	NSDate *min = [NSDate date]; 
	for (int i = 0; i < [lines count]; ++i)
	{
		ECGraphLine *line = [lines objectAtIndex:i];
		NSArray *points = line.points;
		for (int j = 0; j < [points count]; ++j)
		{
			ECGraphPoint *graphicPoint = [points objectAtIndex:j];
			if ([graphicPoint.xDateValue compare:max] == NSOrderedDescending) 
			{
				max = graphicPoint.xDateValue;
			}
			
			if ([graphicPoint.xDateValue compare:min] == NSOrderedAscending)
			{
				min = graphicPoint.xDateValue;
			}
		}
	}
	int durationHours = [self getHoursFrom:min To:max];
	return durationHours;
}

-(int)getYMaxFromLines:(NSArray *)lines
{
	int max = INT_MIN;
	for (int i = 0; i < [lines count]; ++i)
	{
		ECGraphLine *line = [lines objectAtIndex:i];
		NSArray *points = line.points;
		for (int j = 0; j < [points count]; ++j)
		{
			ECGraphPoint *graphicPoint = [points objectAtIndex:j];
			if(graphicPoint.yValue > max)
			{
				max = graphicPoint.yValue;
			}
		}
	}
	return max;
}

-(UIColor *)getRandomColor
{
	CGFloat red = random()%256;
	CGFloat green = random()%256;
	CGFloat bule = random()%256;
	UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:bule/255.0 alpha:1];
	return color;
}

@end

@implementation ECGraph
@synthesize backgroundColor = _backgroundColor;
@synthesize graphStatus = _graphStatus,timeFormat = _timeFormat,graphMode = _graphMode,pointType = _pointType;
@synthesize xSpacing = _xSpacing,ySpacing = _ySpacing;
@synthesize xaxisTitle = _xaxisTitle,yaxisTitle = _yaxisTitle,graphicTitle = _graphicTitle;
@synthesize xaxisDateFormat = _xaxisDateFormat,yaxisDateFormat = _yaxisDateFormat;
@synthesize delegate = _delegate;

-(id)initWithFrame:(CGRect)frame withContext:(CGContextRef)context isPortrait:(BOOL)isPortrait
{
	if (self = [super init]) 
	{
		_context = context;
		_frame = frame;
		_graphStatus	= isPortrait ? ECGraphStatusPortrait : ECGraphStatusLandscape;
		_timeFormat	= ECGraphTimeFormat24;
		_graphMode		= ECGraphModeNormal;
		_pointType		= ECGraphPointTypeCircle;
		
		_graphicTitle = @"";
		_xaxisDateFormat = @"MM-dd";
		_yaxisDateFormat = @"MM-dd";
		
		//get the screen height and width
		_screenHeight = isPortrait ? PORTRAIT_SCREEN_HEIGHT : LANDSCAPE_SCREEN_HEIGHT;
		_screenWidth = isPortrait ? PORTRAIT_SCREEN_WIDTH : LANDSCAPE_SCREEN_WIDTH;
		
		//convert the coordinate left top(0,0) to left bottom(0,0)
		_xaxisStart = CGPointMake(_frame.origin.x + XAXIS_OFFSET + 10, _screenHeight - _frame.origin.y - YAXIS_OFFSET); //_frame.origin.x + XAXIS_OFFSET - 1 correct x-axis position
		_xaxisEnd = CGPointMake(_frame.origin.x + _frame.size.width - XAXIS_OFFSET, _screenHeight - _frame.origin.y - YAXIS_OFFSET);
		_yaxisStart = CGPointMake(_frame.origin.x + XAXIS_OFFSET + 10, _screenHeight - _frame.origin.y - YAXIS_OFFSET);
		_yaxisEnd = CGPointMake(_frame.origin.x + XAXIS_OFFSET + 10, _screenHeight - _frame.origin.y - YAXIS_OFFSET - _frame.size.height + 2*YAXIS_OFFSET);
		
		//set spacing count
		_xSpacing = XSPACEING;
		_ySpacing = YSPACEING;
		//get XY-axis length
		_xaxisLength = abs(_xaxisStart.x - _xaxisEnd.x);
		_yaxisLength = abs(_yaxisStart.y - _yaxisEnd.y);
		
		srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF));
	}
	return self;
}

-(void)drawCurveWithLines:(NSArray *)lines lineWidth:(int)lineWidth color:(UIColor *)color
{
	
	//draw background
	CGRect blockFrame = CGRectMake(_yaxisEnd.x,_yaxisEnd.y,_xaxisLength,_yaxisLength);
	[_backgroundColor set];
	UIRectFill(blockFrame);
	
	//draw titles
	[self drawXYAxisTitleWithColor:[UIColor blackColor]];
	//draw X-axis and Y-axis
	CGContextBeginPath(_context);
	CGContextSetLineWidth(_context, lineWidth);
	CGContextMoveToPoint(_context, _xaxisStart.x, _xaxisStart.y);
	CGContextAddLineToPoint(_context, _xaxisEnd.x, _xaxisEnd.y);
	CGContextClosePath(_context);
	[color setStroke];
	CGContextStrokePath(_context);
	
	CGContextBeginPath(_context);
	CGContextSetLineWidth(_context, lineWidth);
	CGContextMoveToPoint(_context, _yaxisStart.x, _yaxisStart.y);
	CGContextAddLineToPoint(_context, _yaxisEnd.x, _yaxisEnd.y);
	CGContextClosePath(_context);
	[color setStroke];
	CGContextStrokePath(_context);
	
	//get each line to set the boundary
	if ([lines count] == 0)
	{
		NSLog(@"%@",@"no lines in the array");
		return;
	}
	
	ECGraphLine *line = [lines objectAtIndex:0];
	if(line.isXDate)
	{
		_minDate = [[NSDate alloc] init];
		int durationDays = [self getXDaysFromLines:lines minDate:_minDate];
		if (durationDays == 1) {
			int durationHours = [self getXHoursFromLines:lines];
			_xSpacingLength = (float)_xaxisLength/_xSpacing;
			
			while (_xSpacing%durationHours != 0) 
			{
				durationHours++;
			}
			
			BOOL ignoreSomeDateStr = NO;
			if (durationDays > XDISPLAYSTR_MAX_COUNT) {	//if the durationDays is more then 10,need to set display the date str by very 10 * pointsCount
				ignoreSomeDateStr = YES;
			}
			
			_xPointsCount = _xSpacing/durationHours;
			
			for (int i = 1; i <= durationHours; ++i) 
			{
				NSCalendar *dateCalendar = [NSCalendar currentCalendar];
				NSDateComponents *comps = [[NSDateComponents alloc] init];
				[comps setHour:i];
				NSDate *date = [dateCalendar dateByAddingComponents:comps toDate:_minDate options:0];
				NSString *dateStr = [ECCommon sOfD:date Withforamt:kDEFAULT_HOUR_FORMAT];
				if (ignoreSomeDateStr && i % XDISPLAYSTR_MAX_COUNT == 0) {
					[self drawWords:dateStr AtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*i*_xSpacingLength - 15,_xaxisStart.y + 5) color:[UIColor blackColor]];
					[self drawXLineAtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*i*_xSpacingLength,_xaxisStart.y)
								 lineWidth:2 color:[UIColor blackColor] highlighted:YES];
				}
				else if(ignoreSomeDateStr && i % XDISPLAYSTR_MAX_COUNT != 0){
					[self drawXLineAtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*i*_xSpacingLength,_xaxisStart.y)
								 lineWidth:2 color:[UIColor blackColor] highlighted:NO];
				}
				
				else if(!ignoreSomeDateStr)
				{
					[self drawWords:dateStr AtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*i*_xSpacingLength - 15,_xaxisStart.y + 5) color:[UIColor blackColor]];
					[self drawXLineAtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*i*_xSpacingLength,_xaxisStart.y)
								 lineWidth:2 color:[UIColor blackColor] highlighted:YES];
				}
			}
		}
		else {
			durationDays -= 1;
			int multiple = ceil((float)durationDays/_xSpacing);	//sample 2.3 is 3
			_xSpacingLength = (float)_xaxisLength/_xSpacing/multiple;
			
			if (multiple == 1)		//durationDays less than 50
			{
				//sample:50%6 = 2 need change 6 to 10
				while (_xSpacing%durationDays != 0) 
				{
					durationDays++;
				}
			}
			else							//durationDays more than 50
			{
				while (durationDays%multiple != 0) 
				{
					durationDays ++;
				}
			}

			
			_xPointsCount = (float)_xSpacing*multiple/durationDays;  //1 day contains how many points
			BOOL ignoreSomeDateStr = NO;
			if (durationDays > XDISPLAYSTR_MAX_COUNT) {	//if the durationDays is more then 5,need to set display the date str by very 10 * pointsCount
				ignoreSomeDateStr = YES;
			}
			
			for (int i = multiple; i <= durationDays; i += multiple) 
			{
				NSCalendar *dateCalendar = [NSCalendar currentCalendar];
				NSDateComponents *comps = [[NSDateComponents alloc] init];
				[comps setDay:i];
				NSDate *date = [dateCalendar dateByAddingComponents:comps toDate:_minDate options:0];
				NSString *dateStr = [ECCommon sOfD:date Withforamt:_xaxisDateFormat];
				if (ignoreSomeDateStr && i % (XDISPLAYSTR_MAX_COUNT*multiple) == 0) {
					[self drawWords:dateStr AtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*i*_xSpacingLength - 15,_xaxisStart.y + 5) color:[UIColor blackColor]];
					[self drawXLineAtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*i*_xSpacingLength,_xaxisStart.y)
								 lineWidth:2 color:[UIColor blackColor] highlighted:YES];
				}
				else if(ignoreSomeDateStr && i % (XDISPLAYSTR_MAX_COUNT*multiple) != 0){
					[self drawXLineAtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*i*_xSpacingLength,_xaxisStart.y)
								 lineWidth:2 color:[UIColor blackColor] highlighted:NO];
				}
				
				else if(!ignoreSomeDateStr)
				{
					[self drawWords:dateStr AtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*i*_xSpacingLength - 15,_xaxisStart.y + 5) color:[UIColor blackColor]];
					[self drawXLineAtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*i*_xSpacingLength,_xaxisStart.y)
								 lineWidth:2 color:[UIColor blackColor] highlighted:YES];
				}
			}
		}
	}
	
	if(!line.isYDate)
	{
		int max = [self getYMaxFromLines:lines];
		while (max%YSTEPS_COUNT != 0) {
			max++;
		}
		_ySpacingScale = (float)_yaxisLength/max;  //1 present how long distance
		_ySpacingLength = (float)max/YSTEPS_COUNT;
		for (int i = 1; i <= YSTEPS_COUNT; ++i) 
		{
			[self drawWords:[ECCommon sOfI:_ySpacingLength*i] AtPoint:CGPointMake(_xaxisStart.x - 20,_xaxisStart.y - _ySpacingScale*i*_ySpacingLength - 8) color:[UIColor blackColor]];
			[self drawYLineAtPoint:CGPointMake(_xaxisStart.x,_xaxisStart.y - _ySpacingScale*i*_ySpacingLength)
						 lineWidth:2 color:[UIColor blackColor] highlighted:NO];
		}
	}

	//draw lines
	for (int i = 0; i < [lines count]; ++i) 
	{
		ECGraphLine *line = [lines objectAtIndex:i];
		UIColor *color = line.color?line.color:[self getRandomColor];
		[self drawLineWithPoints:line.points lineWidth:2 color:color];
	}
	
}

-(void)drawLineWithPoints:(NSArray *)points lineWidth:(int)lineWidth color:(UIColor *)color
{
	int durationDays1,durationDays2;
	for (int i = 0; i < [points count] - 1; ++i) 
	{
		durationDays1 = [self getDaysFrom:_minDate To:ECCAST(ECGraphPoint,[points objectAtIndex:i]).xDateValue];
		durationDays2 = [self getDaysFrom:_minDate To:ECCAST(ECGraphPoint,[points objectAtIndex:i+1]).xDateValue];
		
		
		[self drawLineFromPoint:CGPointMake(_xaxisStart.x +_xPointsCount*(durationDays1 - 1)*_xSpacingLength,_xaxisStart.y - _ySpacingScale*ECCAST(ECGraphPoint,[points objectAtIndex:i]).yValue) 
						toPoint:CGPointMake(_xaxisStart.x +_xPointsCount*(durationDays2 - 1)*_xSpacingLength,_xaxisStart.y - _ySpacingScale*ECCAST(ECGraphPoint,[points objectAtIndex:i+1]).yValue) lineWidth:2 color:color];
		switch (_pointType) {
			case ECGraphPointTypeCircle:
				[self drawCircleAtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*(durationDays1 - 1)*_xSpacingLength,_xaxisStart.y - _ySpacingScale*ECCAST(ECGraphPoint,[points objectAtIndex:i]).yValue)  
						   withDiameter:5.0 fillColor:color stockeColor:color];
				break;
			case ECGraphPointTypeTriangle:
				[self drawTriangleAtPoint: CGPointMake(_xaxisStart.x +_xPointsCount*(durationDays1 - 1)*_xSpacingLength,_xaxisStart.y - _ySpacingScale*ECCAST(ECGraphPoint,[points objectAtIndex:i]).yValue)
							 withDiameter:5.0 fillColor:color stockeColor:color rotate:2.0];
				break;
			case ECGraphPointTypeSquare:
				[self drawSquareAtPoint: CGPointMake(_xaxisStart.x +_xPointsCount*(durationDays1 - 1)*_xSpacingLength,_xaxisStart.y - _ySpacingScale*ECCAST(ECGraphPoint,[points objectAtIndex:i]).yValue)
							 withDiameter:5.0 fillColor:color stockeColor:color rotate:2.0];
				break;
			default:
				break;
		}
	}
	
	//draw the last point
	durationDays1 = [self getDaysFrom:_minDate To:ECCAST(ECGraphPoint,[points objectAtIndex:[points count] - 1]).xDateValue];
	switch (_pointType) {
		case ECGraphPointTypeCircle:
			[self drawCircleAtPoint:CGPointMake(_xaxisStart.x +_xPointsCount*(durationDays1 - 1)*_xSpacingLength,_xaxisStart.y - _ySpacingScale*ECCAST(ECGraphPoint,[points objectAtIndex:[points count] - 1]).yValue)  
					   withDiameter:5.0 fillColor:color stockeColor:color];
			break;
		case ECGraphPointTypeTriangle:
			[self drawTriangleAtPoint: CGPointMake(_xaxisStart.x +_xPointsCount*(durationDays1 - 1)*_xSpacingLength,_xaxisStart.y - _ySpacingScale*ECCAST(ECGraphPoint,[points objectAtIndex:[points count] - 1]).yValue)
						 withDiameter:5.0 fillColor:color stockeColor:color rotate:2.0];
			break;
		case ECGraphPointTypeSquare:
			[self drawSquareAtPoint: CGPointMake(_xaxisStart.x +_xPointsCount*(durationDays1 - 1)*_xSpacingLength,_xaxisStart.y - _ySpacingScale*ECCAST(ECGraphPoint,[points objectAtIndex:[points count] - 1]).yValue)
					   withDiameter:5.0 fillColor:color stockeColor:color rotate:2.0];
			break;
		default:
			break;
	}
}

-(void)drawHistogramWithItems:(NSArray *)items lineWidth:(int)lineWidth color:(UIColor *)color
{
	
	//draw background
	CGRect blockFrame = CGRectMake(_yaxisEnd.x,_yaxisEnd.y,_xaxisLength,_yaxisLength);
	[_backgroundColor set];
	UIRectFill(blockFrame);
	
	//draw titles
	[self drawXYAxisTitleWithColor:[UIColor blackColor]];
	//draw X-axis and Y-axis
	CGContextBeginPath(_context);
	CGContextSetLineWidth(_context, lineWidth);
	CGContextMoveToPoint(_context, _xaxisStart.x, _xaxisStart.y);
	CGContextAddLineToPoint(_context, _xaxisEnd.x, _xaxisEnd.y);
	CGContextClosePath(_context);
	[color setStroke];
	CGContextStrokePath(_context);
	
	CGContextBeginPath(_context);
	CGContextSetLineWidth(_context, lineWidth);
	CGContextMoveToPoint(_context, _yaxisStart.x, _yaxisStart.y);
	CGContextAddLineToPoint(_context, _yaxisEnd.x, _yaxisEnd.y);
	CGContextClosePath(_context);
	[color setStroke];
	CGContextStrokePath(_context);
	
	if ([items count] == 0)
	{
		NSLog(@"%@",@"no items in the array");
		return;
	}
	
	ECGraphItem *item = [items objectAtIndex:0];
    int max = 0;
    
	if (item.isPercentage) {
		max = 100;
    }else{
        max = item.max;
    }
    
    _ySpacingScale = (float)_yaxisLength/max;
    _ySpacingLength = (float)max/YSTEPS_COUNT;
    for (int i = 1; i <= YSTEPS_COUNT; ++i){
        [self drawWords:[ECCommon sOfI:_ySpacingLength*i] AtPoint:CGPointMake(_xaxisStart.x - 25,_xaxisStart.y - _ySpacingScale*i*_ySpacingLength - 8) color:[UIColor blackColor]];
        [self drawYLineAtPoint:CGPointMake(_xaxisStart.x,_xaxisStart.y - _ySpacingScale*i*_ySpacingLength)
						 lineWidth:2 color:[UIColor blackColor] highlighted:NO];
    }
	
	
	//draw Histogram
	float itemsLength = 0;
	int itemsCount = (int)[items count];
	for (int i = 0; i < itemsCount; ++i){
		ECGraphItem *item = [items objectAtIndex:i];
		itemsLength += item.width;
	}
	
	float retainLength = _xaxisLength - itemsLength;
	_histogramSpacing = (float)retainLength/(itemsCount + 1);
	_histogramStartX = _xaxisStart.x +_histogramSpacing;
    
	for (int i = 0; i < itemsCount; ++i){
		ECGraphItem *item = [items objectAtIndex:i];
		UIColor *color = item.color?item.color:[self getRandomColor];
		[self drawHistogramWithItem:item index:i color:color];
	}
    
}

-(void)drawHistogramWithItem:(ECGraphItem *)item index:(int)index color:(UIColor *)color
{
	if (index != 0) 
		_histogramStartX += _histogramSpacing + item.width;
        
	CGRect rect = CGRectMake(_histogramStartX, _xaxisStart.y - _ySpacingScale*item.yValue - 1,item.width, _ySpacingScale*item.yValue);
    
	[color setFill];
	[[UIColor clearColor] setStroke];
	CGContextAddRect(_context,rect);
	CGContextDrawPath(_context, kCGPathFillStroke);
	[[UIColor blackColor] set];
    
    // Get percentages and write them above bars
//	NSString *percentage = [NSString stringWithFormat:@"%.1f%%",item.per];
//    
//    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:8]};
//    
//	[percentage drawAtPoint:CGPointMake(_histogramStartX,_xaxisStart.y - _ySpacingScale*item.yValue - 15) withAttributes:textAttributes];
    
    UILabel *barTitlelbl = [[UILabel alloc] initWithFrame:CGRectMake(_histogramStartX, _xaxisStart.y + 20, item.width, 20)];
    barTitlelbl.transform = CGAffineTransformMakeRotation(-1.57);

	barTitlelbl.text = item.name;
	barTitlelbl.textAlignment = NSTextAlignmentRight;
	barTitlelbl.backgroundColor = [UIColor clearColor];
	barTitlelbl.font = [UIFont systemFontOfSize:12];
    barTitlelbl.frame = CGRectMake(barTitlelbl.frame.origin.x, _xaxisStart.y + item.width/6, barTitlelbl.frame.size.width , 100);
	[ECCAST(UIView,_delegate) addSubview:barTitlelbl];
    
}

@end 