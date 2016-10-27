//
//  INWeeksInfiniteVerticalScrollView.m
//  urticariapp
//
//  Created on 22/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "INWeeksInfiniteVerticalScrollView.h"
#import "INWeekInVertScroll.h"


@interface INWeeksInfiniteVerticalScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *visibleLabels;
@property (nonatomic, strong) UIView *labelContainerView;

@end





@implementation INWeeksInfiniteVerticalScrollView

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(self.frame.size.width, 5 * self.frame.size.width);
        
        _visibleLabels = [[NSMutableArray alloc] init];
        
        _labelContainerView = [[UIView alloc] init];
        self.labelContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        self.labelContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.labelContainerView];
        
        [self.labelContainerView setUserInteractionEnabled:YES];
        self.delegate = self;
        
        [self setShowsVerticalScrollIndicator:NO];
    }
    
    return self;
}


#pragma mark - Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentHeight = [self contentSize].height;
    CGFloat centerOffsetY = (contentHeight - [self bounds].size.height) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
    
    if (distanceFromCenter > (contentHeight / 4.0))
    {
        self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
        
        // move content by the same amount so it appears to stay still
        for (INWeekInVertScroll *week in self.visibleLabels) {
            CGPoint center = [self.labelContainerView convertPoint:week.center toView:self];
            center.y += (centerOffsetY - currentOffset.y);
            week.center = [self convertPoint:center toView:self.labelContainerView];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.labelContainerView];
    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
    
    [self tileLabelsFromMinX:minimumVisibleY toMaxX:maximumVisibleY];
    
    if (self.iterationDelegate)
    {
     
        INWeekInVertScroll *first = [self.visibleLabels objectAtIndex:2];
        [self.iterationDelegate currentMonth:first.monday];
    }
}

#pragma mark - Label Tiling

- (INWeekInVertScroll *)insertWeekWithMonday:(NSDate *)monday
{
    CGFloat width = self.labelContainerView.frame.size.width;
    CGFloat height = self.bounds.size.height;
    INWeekInVertScroll *week = [[INWeekInVertScroll alloc] initWithFrame:CGRectMake(0, 0, width, height / 6)];
    
    week.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    week.monday = monday;
    
    [self.labelContainerView addSubview:week];
    
    return week;
}

- (CGFloat)placeNewWeekOnBotton:(CGFloat)bottomEdge previousDate:(NSDate *)prevDate isNextMonyh:(BOOL)isNextMonth
{
    if (isNextMonth) {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSInteger prevWeekMonth = [cal component:NSCalendarUnitMonth fromDate:prevDate];
        INWeekInVertScroll *week  = [self insertWeekWithMonday:prevDate];
        [self.visibleLabels addObject:week]; // add rightmost label at the end of the array
        week.month = prevWeekMonth +1;
        week.isFirstWeek = YES;
        CGRect frame = [week frame];
        frame.origin.x = 0;
        frame.origin.y = bottomEdge;
        [week setFrame:frame];
        
        return CGRectGetMaxY(frame);
        
    } else {
        
        NSDate *date = [prevDate dateByAddingTimeInterval:+7*86400];
        NSDate *nextMonday =  [prevDate dateByAddingTimeInterval:+14*86400];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSInteger nextWeekMonth = [cal component:NSCalendarUnitMonth fromDate:nextMonday];
        NSInteger currentWeekMont = [cal component:NSCalendarUnitMonth fromDate:date];
        
        if (nextWeekMonth == currentWeekMont) {
            
            INWeekInVertScroll *week  = [self insertWeekWithMonday:date];
            [self.visibleLabels addObject:week]; // add rightmost label at the end of the array
            week.month = currentWeekMont;
            CGRect frame = [week frame];
            frame.origin.x = 0;
            frame.origin.y = bottomEdge;
            [week setFrame:frame];
            
            return CGRectGetMaxY(frame);
        } else {
            INWeekInVertScroll *week  = [self insertWeekWithMonday:date];
            [self.visibleLabels addObject:week]; // add rightmost label at the end of the array
            week.month = currentWeekMont;
            week.isLastWeek = YES;
            CGRect frame = [week frame];
            frame.origin.x = 0;
            frame.origin.y = bottomEdge;
            [week setFrame:frame];
            
            return CGRectGetMaxY(frame);
        }
    }
}

- (CGFloat)placeNewWeekOnTop:(CGFloat)topEdge nextDate:(NSDate *)nextDate isPreviousMonth:(BOOL)isNextMonth
{
    if (isNextMonth) {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSInteger prevWeekMonth = [cal component:NSCalendarUnitMonth fromDate:nextDate];
        INWeekInVertScroll *week  = [self insertWeekWithMonday:nextDate];
        [self.visibleLabels insertObject:week atIndex:0]; // add leftmost label at the beginning of the array
        week.month = prevWeekMonth;
        week.isLastWeek = YES;
        CGRect frame = [week frame];
        frame.origin.x = 0;
        frame.origin.y = topEdge- frame.size.height;
        [week setFrame:frame];
        
        return CGRectGetMinY(frame);
        
    } else {
        NSDate *date = [nextDate dateByAddingTimeInterval:-7*86400];
        NSDate *previousMonday =  [nextDate dateByAddingTimeInterval:-86400];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSInteger previousWeekMonth = [cal component:NSCalendarUnitMonth fromDate:previousMonday];
        NSInteger currentWeekMont = [cal component:NSCalendarUnitMonth fromDate:date];
        
        if (previousWeekMonth == currentWeekMont) {
            
            INWeekInVertScroll *week  = [self insertWeekWithMonday:date];
            [self.visibleLabels insertObject:week atIndex:0]; // add leftmost label at the beginning of the array
            week.month = currentWeekMont;
            CGRect frame = [week frame];
            frame.origin.x = 0;
            frame.origin.y = topEdge- frame.size.height;
            [week setFrame:frame];
            
            return CGRectGetMinY(frame);
            
        } else {
            
            INWeekInVertScroll *week  = [self insertWeekWithMonday:date];
            [self.visibleLabels insertObject:week atIndex:0]; // add leftmost label at the beginning of the array
            week.month = currentWeekMont +1;
            week.isFirstWeek = YES;
            CGRect frame = [week frame];
            frame.origin.x = 0;
            frame.origin.y = topEdge- frame.size.height;
            [week setFrame:frame];
            
            return CGRectGetMinY(frame);
        }
    }
}

- (void)tileLabelsFromMinX:(CGFloat)minimumVisibleY toMaxX:(CGFloat)maximumVisibleY {
    
    if ([self.visibleLabels count] == 0) {
        
        // First Week.
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
        NSInteger todayWeekday = components.weekday;
        NSDate *firstMonday;
        if (todayWeekday == 1) {
            firstMonday = [date dateByAddingTimeInterval:-6*86400];
        } else {
            firstMonday = [date dateByAddingTimeInterval:-(86400 * (todayWeekday -2))];
        }
        [self placeNewWeekOnTop:minimumVisibleY nextDate:firstMonday isPreviousMonth:NO];
    }
    
    // add labels that are missing on the bottom
    INWeekInVertScroll *lastLabel = [self.visibleLabels lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastLabel frame]);
    while (bottomEdge < maximumVisibleY)
    {
        INWeekInVertScroll *week = [self.visibleLabels lastObject];
        NSDate *firstDate =week.monday;
        bottomEdge = [self placeNewWeekOnBotton:bottomEdge previousDate:firstDate isNextMonyh:week.isLastWeek];
        
    }
    
    // add labels that are missing on left side
    INWeekInVertScroll *firstLabel = self.visibleLabels[0];
    CGFloat leftEdge = CGRectGetMinY([firstLabel frame]);
    while (leftEdge > minimumVisibleY)
    {
        INWeekInVertScroll *week = [self.visibleLabels firstObject];
        NSDate *lastDate = week.monday;
        leftEdge = [self placeNewWeekOnTop:leftEdge nextDate:lastDate isPreviousMonth:week.isFirstWeek];
    }
    
    // remove labels that have fallen off right edge
    lastLabel = [self.visibleLabels lastObject];
    while ([lastLabel frame].origin.x > maximumVisibleY)
    {
        [lastLabel removeFromSuperview];
        [self.visibleLabels removeLastObject];
        lastLabel = [self.visibleLabels lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstLabel = self.visibleLabels[0];
    while (CGRectGetMaxY([firstLabel frame]) < minimumVisibleY)
    {
        [firstLabel removeFromSuperview];
        [self.visibleLabels removeObjectAtIndex:0];
        firstLabel = self.visibleLabels[0];
    }
}

#pragma mark - Scroll Delegate
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat height = self.bounds.size.height;
    
    CGFloat yExpected = targetContentOffset -> y;
    NSInteger nearComplete =round(yExpected * 6 / height);
    
    targetContentOffset -> y = -10 + nearComplete * height / 6.0;
}

@end
