//
//  UrticariaAppConfiguration.m
//  urticariapp
//
//  Created by enrique on 28/9/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "UrticariaAppConfiguration.h"

@implementation UrticariaAppConfiguration

+ (UIColor *)getPrimaryColor {
    
    return [UIColor colorWithRed:((float)((0x00679F & 0xFF0000) >> 16))/255.0
                           green:((float)((0x00679F & 0x00FF00) >>  8))/255.0
                            blue:((float)((0x00679F & 0x0000FF) >>  0))/255.0
                           alpha:1.];
}

+ (NSString *)getAAUCUrl {
    return @"http://www.urticariacronica.org/?utm_source=app&utm_medium=app&utm_campaign=logo";
}

+ (NSString *)getMemberUrl {
    return @"https://docs.google.com/forms/d/13LprW5q24OTfVAMBzx1L3HUsl0uE_6SW8ef5tjlbtvo/viewform";
}

+ (NSString *)getUrticariaUrl {
    return @"http://www.urticariacronica.org/la-urticaria/?utm_source=app&utm_medium=app&utm_campaign=urticariapp";
}


@end
