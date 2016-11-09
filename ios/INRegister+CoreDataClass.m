//
//  INRegister+CoreDataClass.m
//  urticariapp
//
//  Created on 23/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "INRegister+CoreDataClass.h"

@implementation INRegister


+(NSUInteger)angioOptions
{
    return 8;
}
+(NSUInteger)limitOptions
{
    return 7;
}



+(NSString *)nameAngioOption:(INRegisterAngioedema)regAng
{
    switch (regAng) {
        case INRegisterAngioedemaNone:
            return @"";
            break;
        case INRegisterAngioedemaLips:
            return NSLocalizedString(@"Labios", nil);
            break;
        case INRegisterAngioedemaTongue:
            return NSLocalizedString(@"Lengua", nil);
            break;
        case INRegisterAngioedemaEyes:
            return NSLocalizedString(@"Ojos", nil);
            break;
        case INRegisterAngioedemaThroat:
            return NSLocalizedString(@"Garganta", nil);
            break;
        case INRegisterAngioedemaFace:
            return NSLocalizedString(@"Cara", nil);
            break;
        case INRegisterAngioedemaHands:
            return NSLocalizedString(@"Manos", nil);
            break;
        case INRegisterAngioedemaFoots:
            return NSLocalizedString(@"Pies", nil);
            break;
        case INRegisterAngioedemaGenitals:
            return NSLocalizedString(@"Genitales", nil);
            break;
            
        default:
            break;
    }
}
+(NSString *)nameLimitationsOption:(INRegisterLimitation)regLim
{
    switch (regLim) {
        case INRegisterLimitationNone:
            return @"";
            break;
        case INRegisterLimitationWork:
            return NSLocalizedString(@"Trabajo", nil);
            break;
        case INRegisterLimitationSport:
            return NSLocalizedString(@"Deporte", nil);
            break;
        case INRegisterLimitationFreeTime:
            return NSLocalizedString(@"Ocio", nil);
            break;
        case INRegisterLimitationHobby:
            return NSLocalizedString(@"Hobby", nil);
            break;
        case INRegisterLimitationClothes:
            return NSLocalizedString(@"Ropa", nil);
            break;
        case INRegisterLimitationSleep:
            return NSLocalizedString(@"Sueño", nil);
            break;
        case INRegisterLimitationSexualLife:
            return NSLocalizedString(@"Vida sexual", nil);
            break;
            
        default:
            break;
    }
}

@end
