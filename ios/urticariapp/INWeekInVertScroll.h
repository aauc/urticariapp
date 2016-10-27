//
//  INWeekInVertScroll.h
//  urticariapp
//
//  Created on 22/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INWeekInVertScroll : UIView

@property (nonatomic, strong) NSDate *monday;
@property (nonatomic) NSInteger month;

@property (nonatomic) BOOL isLastWeek;
@property (nonatomic) BOOL isFirstWeek;

@end
