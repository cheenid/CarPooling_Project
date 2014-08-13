//
//  YZDataBaseMgr.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-18.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZDataBaseMgr.h"
#import "IQDatabaseManagerSubclass.h"

@implementation YZDataBaseMgr

+(NSURL*)modelURL
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CarPoolModel" withExtension:IQ_MODEL_EXTENSION_momd];
    
    if (modelURL == nil)
        modelURL = [[NSBundle mainBundle] URLForResource:@"CarPoolModel" withExtension:IQ_MODEL_EXTENSION_mom];
    
    return modelURL;
}

- (BOOL)save
{
    NSError *error = nil;
    if (![self.managedObjectContext save:&error] || error)
    {
        DEBUG_METHOD(@"错误：%@",[error localizedDescription]);
        return NO;
    }
    return YES;
}


- (NSManagedObject*)fetchObjectInTable:(NSString*)tableName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects && fetchedObjects.count > 0)
    {
        return (NSManagedObject*)[fetchedObjects firstObject];
    }
    
    return nil;
}


- (NSManagedObject*)fetchPersonalData
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonalData"
                                              inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (fetchedObjects && fetchedObjects.count > 0)
    {
        return (NSManagedObject*)[fetchedObjects firstObject];
    }
    
    return nil;
}

- (void)insertOrUpdatePersonalData:(NSDictionary*)attribute
                                   complete:(void(^)(NSManagedObject *object,BOOL ret))result
{
    if (attribute == nil)
    {
        result(nil,NO);
    }
    
    NSManagedObject *object = [self fetchObjectInTable:NSStringFromClass([PersonalData class])];
    if (object == nil)
    {
        object = [NSEntityDescription insertNewObjectForEntityForName:@"PersonalData"
                                               inManagedObjectContext:self.managedObjectContext];
    }
    
    if (object)
    {
        NSArray *allKeys = [attribute allKeys];
        
        for (NSString *aKey in allKeys)
        {
            id value = [attribute objectForKey:aKey];
            [object setValue:value forKey:aKey];
        }
    }
    
    if ( [self save])
    {
        result(object,YES);
    }
    else
    {
        result(nil,NO);
    }
}

- (NSManagedObject*)newObjectInTable:(NSString*)tableName
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:tableName
                                                            inManagedObjectContext:self.managedObjectContext];
    return object;
}

#pragma mark -路线临时存储

- (void)insertOrUpdateCtRoute:(NSDictionary*)attribute
                     complete:(void(^)(NSManagedObject *object,BOOL ret))result
{
    if (attribute == nil)
    {
        result(nil, NO);
    }
    NSManagedObject *object = [self fetchObjectInTable:NSStringFromClass([CreateRouteEntity class])];
    if (object == nil)
    {
        object = [self newObjectInTable:NSStringFromClass([CreateRouteEntity class])];
    }
    
    if (object)
    {
        for (NSString *aKey in [attribute allKeys])
        {
            id value = [attribute objectForKey:aKey];
            if ([value isKindOfClass:[NSArray class]])
            {
                
            }
            else
            {
                [object setValue:value forKey:aKey];
            }
        }
    }

    
}

#pragma mark -TotalPointsEntity

- (TotalPointsEntity*)fetchTotalScore
{
    return (TotalPointsEntity*)[self firstObjectFromTable:NSStringFromClass([TotalPointsEntity class]) wherePredicate:nil];
}

- (void)insertOrUpdateTotalScore:(NSDictionary*)attribute
                        complete:(void(^)(TotalPointsEntity *object,BOOL ret))result;
{
    if (attribute == nil)
    {
        result(nil,NO);
    }
    NSManagedObject *object = [self fetchObjectInTable:NSStringFromClass([TotalPointsEntity class])];
    if (object == nil)
    {
        object = [NSEntityDescription insertNewObjectForEntityForName:@"TotalPointsEntity"
                                               inManagedObjectContext:self.managedObjectContext];
    }
    
    if (object)
    {
        NSArray *allKeys = [attribute allKeys];
        
        for (NSString *aKey in allKeys)
        {
            id value = [attribute objectForKey:aKey];
            [object setValue:value forKey:aKey];
        }
    }
    
    if ([self save])
    {
       result((TotalPointsEntity*)object,YES);
    }
    else
    {
        result(nil,NO);
    }

}
@end
