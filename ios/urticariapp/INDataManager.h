//
//  INDataManager.h
//  urticariapp
//
//  Created on 23/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface INDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+(INDataManager *)sharedManager;

@end
