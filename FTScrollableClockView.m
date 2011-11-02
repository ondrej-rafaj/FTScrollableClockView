//
//  FTScrollableClockView.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 02/11/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTScrollableClockView.h"


#pragma mark Time object implementation

@implementation FTScrollableClockViewTime
@synthesize hours;
@synthesize minutes;

- (NSString *)description {
	return [NSString stringWithFormat:@"FTScrollableClockViewTime - Scrollable clock time is: %d:%d", hours, minutes];
}

@end

#pragma mark Scrolling clock implementation

@implementation FTScrollableClockView

@synthesize hours;
@synthesize minutes;
@synthesize timeFormat;
@synthesize delegate;


#pragma mark Creating elements

- (UILabel *)timeLabelWithValue:(NSInteger)value forScrollView:(UIScrollView *)scrollView {
	int y = (value * [self height]);
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, y, ([self width] / 2), [self height])] autorelease];
	NSString *textValue;
	if (scrollView == hours && timeFormat == FTScrollableClockViewTimeFormat12H) {
		if (value > 12) value -= 12;
	}
	textValue = [NSString stringWithFormat:@"%@%d", ((value < 10) ? @"0" : @""), value];
	[label setText:textValue];
	[label setFont:[UIFont boldSystemFontOfSize:14]];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setTextColor:[UIColor darkTextColor]];
	[label setBackgroundColor:[UIColor clearColor]];
	return label;
}

- (void)createHoursScrollView {
	hourLabels = [[NSMutableArray alloc] init];
	hours = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ([self width] / 2), [self height])];
	[hours setShowsVerticalScrollIndicator:NO];
	[hours setShowsHorizontalScrollIndicator:NO];
	[hours setDelegate:self];
	[hours setBackgroundColor:[UIColor clearColor]];
	for (int i = 0; i < 24; i++) {
		UILabel *label = [self timeLabelWithValue:i forScrollView:hours];
		[hourLabels addObject:label];
		[hours addSubview:label];
	}
	[hours setContentSize:CGSizeMake([hours width], ([hourLabels count] * [hours height]))];
	[self addSubview:hours];
}

- (void)createMinutesScrollView {
	minuteLabels = [[NSMutableArray alloc] init];
	minutes = [[UIScrollView alloc] initWithFrame:CGRectMake(([self width] / 2), 0, ([self width] / 2), [self height])];
	[minutes setShowsVerticalScrollIndicator:NO];
	[minutes setShowsHorizontalScrollIndicator:NO];
	[minutes setDelegate:self];
	[minutes setBackgroundColor:[UIColor clearColor]];
	for (int i = 0; i < 60; i++) {
		UILabel *label = [self timeLabelWithValue:i forScrollView:minutes];
		[minuteLabels addObject:label];
		[minutes addSubview:label];
	}
	[minutes setContentSize:CGSizeMake([minutes width], ([minuteLabels count] * [minutes height]))];
	[self addSubview:minutes];
}

- (void)createAllElements {
	[self createHoursScrollView];
	[self createMinutesScrollView];
}

#pragma mark Initialization

- (void)initializeView {
	[self createAllElements];
	
	[self setBackgroundColor:[UIColor clearColor]];
	
	if (!_currentTime) {
		FTScrollableClockViewTime *time = [[FTScrollableClockViewTime alloc] init];
		time.hours = 6;
		time.minutes = 25;
		[self setCurrentTime:time];
		[time release];
	}
}

- (id)initWithFrame:(CGRect)frame currentTime:(FTScrollableClockViewTime *)time andTimeFormat:(FTScrollableClockViewTimeFormat)format {
	timeFormat = format;
    self = [super initWithFrame:frame];
    if (self) {
        [self setCurrentTime:time];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTimeFormat:(FTScrollableClockViewTimeFormat)format {
	timeFormat = format;
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark Scroll view delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	int page = (scrollView.contentOffset.y / [scrollView height]);
	BOOL valueChanged = NO;
	if (scrollView == hours) {
		if (_currentTime.hours != page) valueChanged = YES;
		[_currentTime setHours:page];
	}
	else if (scrollView == minutes) {
		if (_currentTime.minutes != page) valueChanged = YES;
		[_currentTime setMinutes:page];
	}
	if (valueChanged) {
		if ([delegate respondsToSelector:@selector(scrollableClockView:didChangeTime:)]) {
			[delegate scrollableClockView:self didChangeTime:_currentTime];
		}
	}
}

- (void)snapScrollViewToClosestPosition:(UIScrollView *)scrollView {
	int page = (scrollView.contentOffset.y / [scrollView height]);
	CGFloat offset = (page * [scrollView height]);
	[scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self snapScrollViewToClosestPosition:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[self snapScrollViewToClosestPosition:scrollView];
}

#pragma mark Setters & getters

- (void)setCurrentTime:(FTScrollableClockViewTime *)currentTime animated:(BOOL)animated {
	[_currentTime release];
	_currentTime = currentTime;
	[_currentTime retain];
	
	[hours setContentOffset:CGPointMake(0, (_currentTime.hours * [self height])) animated:animated];
	[minutes setContentOffset:CGPointMake(0, (_currentTime.minutes * [self height])) animated:animated];
}

- (void)setCurrentTime:(FTScrollableClockViewTime *)currentTime {
	[self setCurrentTime:currentTime animated:NO];
}

- (FTScrollableClockViewTime *)currentTime {
	return _currentTime;
}

- (void)setFont:(UIFont *)font {
	for (UILabel *l in hourLabels) {
		[l setFont:font];
	}
	for (UILabel *l in minuteLabels) {
		[l setFont:font];
	}
}

- (void)setTextColor:(UIColor *)color {
	for (UILabel *l in hourLabels) {
		[l setTextColor:color];
	}
	for (UILabel *l in minuteLabels) {
		[l setTextColor:color];
	}
}

- (void)setTextAlignment:(UITextAlignment)alignment {
	for (UILabel *l in hourLabels) {
		[l setTextAlignment:alignment];
	}
	for (UILabel *l in minuteLabels) {
		[l setTextAlignment:alignment];
	}
}

#pragma mark Dev helpers

- (NSString *)description {
	return [NSString stringWithFormat:@"FTScrollableClockView - Scrollable clock time is: %d:%d", _currentTime.hours, _currentTime.minutes];
}

#pragma mark Memory management

- (void)dealloc {
	[hours release];
	[minutes release];
	[_currentTime release];
	[hourLabels release];
	[minuteLabels release];
	[super dealloc];
}


@end
