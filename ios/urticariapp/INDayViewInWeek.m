//
//  INDayViewInWeek.m
//  urticariapp
//
//  Created on 22/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "INDayViewInWeek.h"
#import "INCalendarConstants.h"

#import "INRegister+CoreDataClass.h"


@interface INDayViewInWeek ()

@property (nonatomic, strong) UILabel *dayNumberLabel;



@end



@implementation INDayViewInWeek



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UIView *lineV=[[UIView alloc] init];
        UIView *lineH = [[UIView alloc] init];
        self.dayNumberLabel = [[UILabel alloc] init];
        self.dayNumberLabel.textAlignment = NSTextAlignmentCenter;
 
        self.dayNumberLabel.font = FONT_APP17;
        
        lineH.backgroundColor = COLOR_LIGHTGRAY;
        lineV.backgroundColor = COLOR_LIGHTGRAY;
        
        [self addSubview:lineV];
        [self addSubview:lineH];
        [self addSubview:self.dayNumberLabel];
        
        lineV.translatesAutoresizingMaskIntoConstraints = NO;
        lineH.translatesAutoresizingMaskIntoConstraints = NO;
        _dayNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *viewDict = @{@"lineV":lineV,@"lineH":lineH,@"dayNumberLabel":_dayNumberLabel};
        
        NSArray *constrainsts = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[lineH]-0-|" options:0 metrics:nil views:viewDict];
        constrainsts = [constrainsts arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[lineV(1)]-0-|" options:0 metrics:nil views:viewDict]];
        constrainsts = [constrainsts arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[dayNumberLabel]-0-|" options:0 metrics:nil views:viewDict]];
        
        constrainsts = [constrainsts arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineH(1)]-0-|" options:0 metrics:nil views:viewDict]];
        constrainsts = [constrainsts arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lineV]-0-|" options:0 metrics:nil views:viewDict]];
        constrainsts = [constrainsts arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[dayNumberLabel(20)]" options:0 metrics:nil views:viewDict]];
        
        [self addConstraints:constrainsts];
        
    }
    return self;
}

-(void)setDate:(NSDate *)date
{
    _date = date;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
//    NSInteger componentDayInMonth = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
    // Optional To bigest calendars
//    if (componentDayInMonth == 1)
//    {
//        [formatter setDateFormat:@"MMM dd"];
//    }
    
    self.dayNumberLabel.text = [formatter stringFromDate:date];
    
    NSInteger component = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:date];
    if (component ==1 || component ==7) {
      //  self.backgroundColor = COLOR_LIGHTSYSTEMGRAY;
        self.dayNumberLabel.textColor = COLOR_GRAY;
    } else {
      //  self.backgroundColor = [UIColor whiteColor];
        self.dayNumberLabel.textColor = [UIColor blackColor];
        
    }
    
    
}
-(void)setIsEmpty:(BOOL)isEmpty
{
    _isEmpty = isEmpty;
    self.dayNumberLabel.hidden = isEmpty;
}

-(void)setReg:(INRegister *)reg
{
    self.backgroundColor = COLOR_DAY_WITH_REGISTER;
    [self addTarget:self action:@selector(selectDay:) forControlEvents:UIControlEventTouchUpInside];
    _reg = reg;
}

-(void)selectDay:(UIButton *)buttt
{
    self.backgroundColor = COLOR_DAY_SELECTED;
    NSDictionary *userInfo = @{@"register":self.reg,
                               @"day":self};
    NSNotification *not = [NSNotification notificationWithName:@"INDayViewSelectedNotification" object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:not];
}
@end
