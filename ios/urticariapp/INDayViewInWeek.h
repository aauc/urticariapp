//
//  INDayViewInWeek.h
//  urticariapp
//
//  Created on 22/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INRegister;



@interface INDayViewInWeek : UIButton

@property (nonatomic,strong) NSDate *date;

@property (nonatomic)BOOL isEmpty;

@property (nonatomic, strong) INRegister *reg;




@end
