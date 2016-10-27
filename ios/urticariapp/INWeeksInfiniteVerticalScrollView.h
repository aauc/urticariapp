//
//  INWeeksInfiniteVerticalScrollView.h
//  urticariapp
//
//  Created on 22/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol INWeeksInfiniteScrollDelegate

-(void)currentMonth:(NSDate *)monday;

@end


@interface INWeeksInfiniteVerticalScrollView : UIScrollView

@property (nonatomic, weak) id<INWeeksInfiniteScrollDelegate> iterationDelegate;

@end
