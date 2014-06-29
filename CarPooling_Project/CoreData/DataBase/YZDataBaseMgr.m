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

#pragma mark -personalData

- (NSArray*)allObjectsSortByAttribute:(NSString*)attribute
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    return [self allObjectsFromTable:NSStringFromClass([PersonalData class]) sortDescriptor:sortDescriptor];
}

- (NSArray*)allObjectsSortByPredicate:(NSPredicate*)predicate
{
    return [self allObjectsFromTable:NSStringFromClass([PersonalData class]) wherePredicate:predicate];
}

- (PersonalData*)personalDataSortByAccountID:(NSString*)accountID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountID == %@",accountID];
    return (PersonalData*)[self firstObjectFromTable:NSStringFromClass([PersonalData class]) wherePredicate:predicate];
}

- (PersonalData*)insertOrUpdatePersonalData:(NSDictionary*)attribute
{
    return (PersonalData*)[self insertRecordInTable:NSStringFromClass([PersonalData class])
                                      withAttribute:attribute
                                   updateOnExistKey:@"accountID"
                                             equals:[attribute objectForKey:@"accountID"]];
}

// totalScore

- (TotalPointsEntity*)fetchTotalScore
{
    NSString *mobileNo = [[YZKeyChainManager defaultManager]keychainValueForKey:KMobileNO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountID == %@",mobileNo];
    return (TotalPointsEntity*)[self firstObjectFromTable:NSStringFromClass([TotalPointsEntity class]) wherePredicate:predicate];
}

- (TotalPointsEntity*)insertOrUpdateTotalScore:(NSDictionary*)attribute
{
    return (TotalPointsEntity*)[self insertRecordInTable:NSStringFromClass([TotalPointsEntity class])
                                      withAttribute:attribute
                                   updateOnExistKey:@"accountID"
                                             equals:[attribute objectForKey:@"accountID"]];
}
@end
