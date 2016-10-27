//
//  INHeaderWeekView.m
//  urticariapp
//
//  Created on 22/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "INHeaderWeekView.h"

#import "INCalendarConstants.h"

@interface INHeaderWeekView ()

@property (nonatomic, strong) UILabel *monthLabel;

@end




@implementation INHeaderWeekView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = COLOR_LIGHTSYSTEMGRAY;
        
        _monthLabel =[[UILabel alloc] init];
        UILabel *mondayLabel = [[UILabel alloc] init];
        UILabel *tuesdayLabel = [[UILabel alloc] init];
        UILabel *wednesdayLabel = [[UILabel alloc] init];
        UILabel *thusdayLabel = [[UILabel alloc] init];
        UILabel *fridayLabel = [[UILabel alloc] init];
        UILabel *saturdayLabel = [[UILabel alloc] init];
        UILabel *sundayLabel= [[UILabel alloc] init];
        
        _monthLabel.font = FONT_APP20;
        mondayLabel.font = FONT_APP17;
        tuesdayLabel.font = FONT_APP17;
        wednesdayLabel.font = FONT_APP17;
        thusdayLabel.font = FONT_APP17;
        fridayLabel.font = FONT_APP17;
        saturdayLabel.font = FONT_APP17;
        sundayLabel.font = FONT_APP17;
        
        saturdayLabel.textColor = COLOR_GRAY;
        sundayLabel.textColor = COLOR_GRAY;
        
        mondayLabel.text = NSLocalizedString(@"lun", nil);
        tuesdayLabel.text = NSLocalizedString(@"mar", nil);
        wednesdayLabel.text = NSLocalizedString(@"mie", nil);
        thusdayLabel.text = NSLocalizedString(@"jue", nil);
        fridayLabel.text = NSLocalizedString(@"vie", nil);
        saturdayLabel.text = NSLocalizedString(@"sab", nil);
        sundayLabel.text = NSLocalizedString(@"dom", nil);
        
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        mondayLabel.textAlignment = NSTextAlignmentCenter;
        tuesdayLabel.textAlignment = NSTextAlignmentCenter;
        wednesdayLabel.textAlignment = NSTextAlignmentCenter;
        thusdayLabel.textAlignment = NSTextAlignmentCenter;
        fridayLabel.textAlignment = NSTextAlignmentCenter;
        saturdayLabel.textAlignment = NSTextAlignmentCenter;
        sundayLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_monthLabel];
        [self addSubview:mondayLabel];
        [self addSubview:tuesdayLabel];
        [self addSubview:wednesdayLabel];
        [self addSubview:thusdayLabel];
        [self addSubview:fridayLabel];
        [self addSubview:saturdayLabel];
        [self addSubview:sundayLabel];
        
        UIView *line = [[UIView alloc] init];
        line.userInteractionEnabled = NO;
        line.backgroundColor = COLOR_GRAY;
        [self addSubview:line];
        
        line.translatesAutoresizingMaskIntoConstraints = NO;
        
        
#pragma mark - Autolayout.
        
        _monthLabel.translatesAutoresizingMaskIntoConstraints = NO;
        mondayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        tuesdayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        wednesdayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        thusdayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        fridayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        saturdayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        sundayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *dictVisual = NSDictionaryOfVariableBindings(_monthLabel,mondayLabel,tuesdayLabel,wednesdayLabel,thusdayLabel,fridayLabel,saturdayLabel,sundayLabel,line);
        
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-1-[mondayLabel]-2-[tuesdayLabel(==mondayLabel)]-2-[wednesdayLabel(==mondayLabel)]-2-[thusdayLabel(==mondayLabel)]-2-[fridayLabel(==mondayLabel)]-2-[saturdayLabel(==mondayLabel)]-2-[sundayLabel(==mondayLabel)]-1-|" options:0 metrics:nil views:dictVisual];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_monthLabel]-|" options:0 metrics:nil views:dictVisual]];
        
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_monthLabel]-5-[mondayLabel]-|" options:0 metrics:nil views:dictVisual]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tuesdayLabel]-|" options:0 metrics:nil views:dictVisual]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[wednesdayLabel]-|" options:0 metrics:nil views:dictVisual]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[thusdayLabel]-|" options:0 metrics:nil views:dictVisual]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[fridayLabel]-|" options:0 metrics:nil views:dictVisual]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[saturdayLabel]-|" options:0 metrics:nil views:dictVisual]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sundayLabel]-|" options:0 metrics:nil views:dictVisual]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[line]-0-|" options:0 metrics:nil views:dictVisual]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(1)]-0-|" options:0 metrics:nil views:dictVisual]];
        
        [self addConstraints:constraints];
        
    }
    
    return self;
}

-(void)monthTitle:(NSString *)title
{
    self.monthLabel.text = title;
}

@end
