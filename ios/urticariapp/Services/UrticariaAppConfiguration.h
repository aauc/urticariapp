//
//  UrticariaAppConfiguration.h
//  urticariapp
//
//  Created by enrique on 28/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UrticariaAppConfiguration : NSObject


+ (UIColor *)getPrimaryColor;
+ (NSString *)getAAUCUrl;
+ (NSString *)getMemberUrl;
+ (NSString *)getUrticariaUrl;

@end
