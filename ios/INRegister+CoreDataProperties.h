//
//  INRegister+CoreDataProperties.h
//  urticariapp
//
//  Created on 23/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "INRegister+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface INRegister (CoreDataProperties)

+ (NSFetchRequest<INRegister *> *)fetchRequest;


@property (nonatomic, copy) NSNumber  *wheals;
@property (nonatomic, copy) NSNumber  *itch;
@property (nullable, nonatomic, retain) NSData *picture;
@property (nullable, nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSNumber  *angioedema;
@property (nonatomic, copy) NSNumber  * limitations;
@property (nonatomic, copy) NSNumber  *dayOfWeek;


@property (nonatomic, copy) NSNumber  *dateCompMonth;
@property (nonatomic, copy) NSNumber  *dateCompDay;
@property (nonatomic, copy) NSNumber  *dateCompYear;
@property (nonatomic, copy) NSNumber  *dateTimeInterval;



@end

NS_ASSUME_NONNULL_END
