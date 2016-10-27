//
//  INDataManager.m
//  urticariapp
//
//  Created on 23/10/16.
//  Copyright © 2016 aauc. All rights reserved.
//

#import "INDataManager.h"

@interface INDataManager ()

@property (nonatomic, strong) NSManagedObjectContext *privateManagedObjectContext;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end




@implementation INDataManager

+(INDataManager *)sharedManager
{
    static dispatch_once_t onceToken;
    static INDataManager *dataManager = nil;
    dispatch_once(&onceToken, ^{
        
        
        dataManager = [[self alloc] init];
        
        
        dataManager.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [dataManager.managedObjectContext setParentContext:dataManager.privateManagedObjectContext];
        
        [[NSNotificationCenter defaultCenter] addObserver:dataManager selector:@selector(saveInPrivate) name:NSManagedObjectContextDidSaveNotification object:dataManager.managedObjectContext];
        
        
        
    });
    return dataManager;
}

#pragma mark - Core Data stack

-(NSManagedObjectContext *)privateManagedObjectContext
{
    if (_privateManagedObjectContext) {
        return _privateManagedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _privateManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_privateManagedObjectContext setPersistentStoreCoordinator:coordinator];
        
    }
    return _privateManagedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"urtiModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationLibraryCachesDirectory] URLByAppendingPathComponent:@"store.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption , nil];
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        abort();
    }
    return _persistentStoreCoordinator;
}

-(void)saveInPrivate
{
    [self.privateManagedObjectContext performBlock:^{
        
        NSError *error = nil;
        [self.privateManagedObjectContext save:&error];
        if (error) {
            // NSLog(@"Ver error code: %ld \n error:%@",(long)error.code,error.localizedDescription);
        }
    }];
    
}

#pragma mark - Library´s Documents directory

- (NSURL *)applicationLibraryCachesDirectory
{
    NSString *libraryPath= [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath =[libraryPath stringByAppendingPathComponent:@"Caches/"];
    
    return [NSURL fileURLWithPath:cachePath];
    
}

@end
