//
//  INWeekInVertScroll.m
//  urticariapp
//
//  Created on 22/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "INWeekInVertScroll.h"
#import "INDayViewInWeek.h"

#import "INDataManager.h"
#import "INRegister+CoreDataClass.h"

#import "INCalendarConstants.h"

@interface INWeekInVertScroll ()

@property (nonatomic, strong) INDayViewInWeek *mondayView;
@property (nonatomic, strong) INDayViewInWeek *tuesdayView;
@property (nonatomic, strong) INDayViewInWeek *wednesdayView;
@property (nonatomic, strong) INDayViewInWeek *thursdayView;
@property (nonatomic, strong) INDayViewInWeek *fridayView;
@property (nonatomic, strong) INDayViewInWeek *saturdayView;
@property (nonatomic, strong) INDayViewInWeek *sundayView;

@end


@implementation INWeekInVertScroll

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.mondayView = [[INDayViewInWeek alloc] init];
        self.tuesdayView = [[INDayViewInWeek alloc] init];
        self.wednesdayView = [[INDayViewInWeek alloc] init];
        self.thursdayView = [[INDayViewInWeek alloc] init];
        self.fridayView = [[INDayViewInWeek alloc] init];
        self.saturdayView = [[INDayViewInWeek alloc] init];
        self.sundayView = [[INDayViewInWeek alloc] init];
        
        self.saturdayView.backgroundColor = COLOR_LIGHTSYSTEMGRAY;
        self.sundayView.backgroundColor = COLOR_LIGHTSYSTEMGRAY;
        
        [self addSubview:self.mondayView];
        [self addSubview:self.tuesdayView];
        [self addSubview:self.wednesdayView];
        [self addSubview:self.thursdayView];
        [self addSubview:self.fridayView];
        [self addSubview:self.saturdayView];
        [self addSubview:self.sundayView];
        
        self.mondayView.translatesAutoresizingMaskIntoConstraints = NO;
        self.tuesdayView.translatesAutoresizingMaskIntoConstraints = NO;
        self.wednesdayView.translatesAutoresizingMaskIntoConstraints = NO;
        self.thursdayView.translatesAutoresizingMaskIntoConstraints = NO;
        self.fridayView.translatesAutoresizingMaskIntoConstraints = NO;
        self.saturdayView.translatesAutoresizingMaskIntoConstraints = NO;
        self.sundayView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *viewDicts = NSDictionaryOfVariableBindings(_mondayView,_tuesdayView,_wednesdayView,_thursdayView,_fridayView,_saturdayView,_sundayView);
        
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_mondayView]-0-[_tuesdayView(==_mondayView)]-0-[_wednesdayView(==_mondayView)]-0-[_thursdayView(==_mondayView)]-0-[_fridayView(==_mondayView)]-0-[_saturdayView(==_mondayView)]-0-[_sundayView(==_mondayView)]-0-|" options:0 metrics:nil views:viewDicts];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mondayView]-0-|" options:0 metrics:nil views:viewDicts]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mondayView]-0-|" options:0 metrics:nil views:viewDicts]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tuesdayView]-0-|" options:0 metrics:nil views:viewDicts]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_wednesdayView]-0-|" options:0 metrics:nil views:viewDicts]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_thursdayView]-0-|" options:0 metrics:nil views:viewDicts]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_fridayView]-0-|" options:0 metrics:nil views:viewDicts]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_saturdayView]-0-|" options:0 metrics:nil views:viewDicts]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_sundayView]-0-|" options:0 metrics:nil views:viewDicts]];
        
        [self addConstraints:constraints];
        
    }
    return self;
}

-(void)setMonday:(NSDate *)monday
{
    _monday = monday;
    
    self.mondayView.date = monday;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:1];
    self.tuesdayView.date = [cal dateByAddingComponents:dateComponents toDate:self.mondayView.date options:0];
    self.wednesdayView.date =[cal dateByAddingComponents:dateComponents toDate:self.tuesdayView.date options:0];
    self.thursdayView.date =[cal dateByAddingComponents:dateComponents toDate:self.wednesdayView.date options:0];
    self.fridayView.date =[cal dateByAddingComponents:dateComponents toDate:self.thursdayView.date options:0];
    self.saturdayView.date =[cal dateByAddingComponents:dateComponents toDate:self.fridayView.date options:0];
    self.sundayView.date =[cal dateByAddingComponents:dateComponents toDate:self.saturdayView.date options:0];
    
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:monday];
    // Start day
    NSDateComponents *starDayComponents = [[NSDateComponents alloc] init];
    [starDayComponents setHour:0];
    [starDayComponents setMinute:0];
    [starDayComponents setDay:todayComponents.day];
    [starDayComponents setMonth:todayComponents.month];
    [starDayComponents setYear:todayComponents.year];
    NSDate *starDate = [[NSCalendar currentCalendar] dateFromComponents:starDayComponents];
    
    // End day
    
    NSDateComponents *endDayComponents = [[NSDateComponents alloc] init];
    [endDayComponents setHour:23];
    [endDayComponents setMinute:59];
    [endDayComponents setDay:todayComponents.day+7];
    [endDayComponents setMonth:todayComponents.month];
    [endDayComponents setYear:todayComponents.year];
    NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endDayComponents];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"INRegister" inManagedObjectContext:[INDataManager sharedManager].managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateTimeInterval > %f AND dateTimeInterval < %f",starDate.timeIntervalSince1970,endDate.timeIntervalSince1970];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"dateTimeInterval" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    NSArray *registerInWeek = [[INDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    //Filter Day.
   
    NSInteger mondayDay = [cal component:NSCalendarUnitDay fromDate:self.mondayView.date];
    NSInteger tuesdayDay = [cal component:NSCalendarUnitDay fromDate:self.tuesdayView.date];
    NSInteger wednesdayDay = [cal component:NSCalendarUnitDay fromDate:self.wednesdayView.date];
    NSInteger thursdayDay = [cal component:NSCalendarUnitDay fromDate:self.thursdayView.date];
    NSInteger fridayDay = [cal component:NSCalendarUnitDay fromDate:self.fridayView.date];
    NSInteger saturdayDay = [cal component:NSCalendarUnitDay fromDate:self.saturdayView.date];
    NSInteger sundayDay = [cal component:NSCalendarUnitDay fromDate:self.sundayView.date];
    
    for (INRegister *reg in registerInWeek)
    {
        if (reg.dateCompDay.integerValue == mondayDay)
        {
            self.mondayView.reg = reg;
        }
        else if(reg.dateCompDay.integerValue == tuesdayDay)
        {
            self.tuesdayView.reg = reg;
        }
        else if(reg.dateCompDay.integerValue == wednesdayDay)
        {
            self.wednesdayView.reg = reg;
        }
        else if(reg.dateCompDay.integerValue == thursdayDay)
        {
            self.thursdayView.reg = reg;
        }
        else if(reg.dateCompDay.integerValue == fridayDay)
        {
            self.fridayView.reg = reg;
        }
        else if(reg.dateCompDay.integerValue == saturdayDay)
        {
            self.saturdayView.reg = reg;
        }
        else if(reg.dateCompDay.integerValue == sundayDay)
        {
            self.sundayView.reg = reg;
        }
    }
}

-(void)setIsFirstWeek:(BOOL)isFirstWeek
{
    _isFirstWeek = isFirstWeek;
    if (isFirstWeek) {
        [self hiddenDaysOutOfMonth];
    }
    
}

-(void)setIsLastWeek:(BOOL)isLastWeek
{
    _isLastWeek = isLastWeek;
    if (isLastWeek) {
        [self hiddenDaysOutOfMonth];
    }
    
}

-(void)hiddenDaysOutOfMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *compo = [[NSDateComponents alloc] init];
    NSDate *currentDate = self.monday;
    NSDate *dateToAnalize;
    for (NSInteger i=1; i<=7; i++)
    {
        NSInteger days = i-1;
        [compo setDay:days];
        dateToAnalize = [cal dateByAddingComponents:compo toDate:currentDate options:0];
        NSInteger month = [cal component:NSCalendarUnitMonth fromDate:dateToAnalize];
        if ( month !=self.month) {
            [self hiddenDay:i];
        }
        
    }
    
}

-(void)hiddenDay:(NSInteger)day
{
    switch (day) {
        case 1:
            self.mondayView.isEmpty = YES;
            self.mondayView.backgroundColor = [UIColor grayColor];
            break;
        case 2:
            self.tuesdayView.isEmpty = YES;
            self.tuesdayView.backgroundColor = [UIColor grayColor];
            break;
        case 3:
            self.wednesdayView.isEmpty = YES;
            self.wednesdayView.backgroundColor = [UIColor grayColor];
            break;
        case 4:
            self.thursdayView.isEmpty = YES;
            self.thursdayView.backgroundColor = [UIColor grayColor];
            break;
        case 5:
            self.fridayView.isEmpty = YES;
            self.fridayView.backgroundColor = [UIColor grayColor];
            break;
        case 6:
            self.saturdayView.isEmpty = YES;
            self.saturdayView.backgroundColor = [UIColor grayColor];
            break;
        case 7:
            self.sundayView.isEmpty = YES;
            self.sundayView.backgroundColor = [UIColor grayColor];
            break;
    }
}

@end
