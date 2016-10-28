//
//  INMonthViewController.m
//  urticariapp
//
//  Created on 22/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "INMonthViewController.h"

#import "INCalendarConstants.h"

#import "INHeaderWeekView.h"
#import "INWeeksInfiniteVerticalScrollView.h"


@interface INMonthViewController () <INWeeksInfiniteScrollDelegate>

@property (nonatomic, strong) INHeaderWeekView *headerView;

@property (nonatomic, strong) NSDate *currentMonday;
@property (nonatomic, strong) NSDateFormatter *monthYearFormatter;


@end

@implementation INMonthViewController

-(void)loadView {
    UIView *backView = [[UIView alloc] init];
    backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backView.backgroundColor = [UIColor whiteColor];
    
    _headerView = [[INHeaderWeekView alloc] init];
    INWeeksInfiniteVerticalScrollView *infiniteScrollView = [[INWeeksInfiniteVerticalScrollView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -90)];
    infiniteScrollView.iterationDelegate = self;
    
    [backView addSubview:_headerView];
    [backView addSubview:infiniteScrollView];
    
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    infiniteScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDict = @{@"header":_headerView,@"scrollView":infiniteScrollView};
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[header]-0-|" options:0 metrics:nil views:viewsDict];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[scrollView]-0-|" options:0 metrics:nil views:viewsDict]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[header(70)]-0@500-[scrollView]-0-|" options:0 metrics:nil views:viewsDict]];
    
    [backView addConstraints:constraints];
    
    self.view = backView;
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // Initialize month and year formatter
    self.monthYearFormatter = [[NSDateFormatter alloc] init];
    [self.monthYearFormatter setDateFormat:@"MMMM YYYY"];
}

- (void) updateMonthYearLabel {
    if(self.mustUpdateTopLabel && [self currentMonday]) {
        NSString *stringTitle = [self.monthYearFormatter stringFromDate:self.currentMonday];
        [self modifyTopLabel:stringTitle];
    }
}

- (void) modifyTopLabel:(NSString *)text {
    [self.headerView monthTitle:text];
}

#pragma mark - SelectDay


-(void)currentMonth:(NSDate *)monday {
    self.currentMonday = monday;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM YYYY"];
    NSString *stringTitle = [formatter stringFromDate:monday];

    [self modifyTopLabel:stringTitle];
}

@end
