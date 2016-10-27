//
//  INRegister+CoreDataClass.h
//  urticariapp
//
//  Created on 23/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, INRegisterItch)
{
    INRegisterItchNone,
    INRegisterItchLight,
    INRegisterItchMedium,
    INRegisterItchHard
};

typedef NS_OPTIONS(NSUInteger, INRegisterWheals)
{
    INRegisterWhealsNone,
    INRegisterWhealsLight,
    INRegisterWhealsMedium,
    INRegisterWhealsHard
};

typedef NS_OPTIONS(NSUInteger, INRegisterAngioedema)
{
    INRegisterAngioedemaNone = 0,
    INRegisterAngioedemaLips = 1 << 0,
    INRegisterAngioedemaTongue = 1 << 1,
    INRegisterAngioedemaEyes = 1 << 2,
    INRegisterAngioedemaThroat = 1 << 3,
    INRegisterAngioedemaFace = 1 << 4,
    INRegisterAngioedemaHands = 1 << 5,
    INRegisterAngioedemaFoots = 1 << 6,
    INRegisterAngioedemaGenitals = 1 << 7,

};

typedef NS_OPTIONS(NSUInteger, INRegisterLimitation)
{
    INRegisterLimitationNone = 0,
    INRegisterLimitationWork = 1 << 0,
    INRegisterLimitationSport = 1 << 1,
    INRegisterLimitationFreeTime = 1 << 2,
    INRegisterLimitationHobby = 1 << 3,
    INRegisterLimitationClothes = 1 << 4,
    INRegisterLimitationSleep = 1 << 5,
    INRegisterLimitationSexualLife = 1 << 6,
};


@interface INRegister : NSManagedObject

+(NSUInteger)angioOptions;
+(NSUInteger)limitOptions;
+(NSString *)nameAngioOption:(INRegisterAngioedema)regAng;
+(NSString *)nameLimitationsOption:(INRegisterLimitation)regLim;



@end

NS_ASSUME_NONNULL_END

#import "INRegister+CoreDataProperties.h"
