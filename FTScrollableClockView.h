//
//  FTScrollableClockView.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

/**
 
 Example usage
 
 FTScrollableClockView *cv = [[FTScrollableClockView alloc] initWithFrame:CGRectMake(100, 100, 120, 44) andTimeFormat:FTScrollableClockViewTimeFormat12H];
 [cv setDelegate:self];
 [cv setBackgroundColor:[UIColor redColor]];
 [self.view addSubview:cv];
 
 */

#import <UIKit/UIKit.h>

typedef enum {
	
	FTScrollableClockViewTimeFormat24H,
	FTScrollableClockViewTimeFormat12H
	
} FTScrollableClockViewTimeFormat;


@interface FTScrollableClockViewTime : NSObject {
	NSInteger hours;
	NSInteger minutes;
}
@property (nonatomic) NSInteger hours;
@property (nonatomic) NSInteger minutes;
@end;


@class FTScrollableClockView;

@protocol FTScrollableClockViewDelegate <NSObject>

- (void)scrollableClockView:(FTScrollableClockView *)view didChangeTime:(FTScrollableClockViewTime *)time;

@end


@interface FTScrollableClockView : UIView <UIScrollViewDelegate> {
	
	UIScrollView *hours;
	UIScrollView *minutes;
	FTScrollableClockViewTimeFormat timeFormat;
	FTScrollableClockViewTime *_currentTime;
	
	NSMutableArray *hourLabels;
	NSMutableArray *minuteLabels;
	
	id <FTScrollableClockViewDelegate> delegate;
	
}

@property (nonatomic, retain) UIScrollView *hours;
@property (nonatomic, retain) UIScrollView *minutes;
@property (nonatomic, readonly) FTScrollableClockViewTimeFormat timeFormat;
@property (nonatomic, retain) FTScrollableClockViewTime *currentTime;
@property (nonatomic, assign) id <FTScrollableClockViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame currentTime:(FTScrollableClockViewTime *)time andTimeFormat:(FTScrollableClockViewTimeFormat)format;
- (id)initWithFrame:(CGRect)frame andTimeFormat:(FTScrollableClockViewTimeFormat)format;

- (void)setCurrentTime:(FTScrollableClockViewTime *)currentTime animated:(BOOL)animated;

- (void)setFont:(UIFont *)font;
- (void)setTextColor:(UIColor *)color;
- (void)setTextAlignment:(UITextAlignment)alignment;


@end
