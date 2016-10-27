//
//  INRegister+CoreDataProperties.m
//  urticariapp
//
//  Created on 23/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "INRegister+CoreDataProperties.h"

@implementation INRegister (CoreDataProperties)

+ (NSFetchRequest<INRegister *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"INRegister"];
}

@dynamic wheals;
@dynamic itch;
@dynamic picture;
@dynamic note;
@dynamic angioedema;
@dynamic limitations;
@dynamic dayOfWeek;
@dynamic dateCompDay;
@dynamic dateCompYear;
@dynamic dateCompMonth;
@dynamic dateTimeInterval;

@end
