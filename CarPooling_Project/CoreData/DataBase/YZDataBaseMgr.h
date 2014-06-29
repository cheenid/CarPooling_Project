//
//  YZDataBaseMgr.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-18.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "IQDatabaseManager.h"
#import "PersonalData.h"
#import "MsgEntity.h"
#import "ScoreRecordsEntity.h"
#import "TotalPointsEntity.h"

@interface YZDataBaseMgr : IQDatabaseManager

// personalData
- (NSArray*)allObjectsSortByPredicate:(NSPredicate*)predicate;
- (PersonalData*)personalDataSortByAccountID:(NSString*)accountID;
- (PersonalData*)insertOrUpdatePersonalData:(NSDictionary*)attribute;

// totalScore
- (TotalPointsEntity*)fetchTotalScore;
- (TotalPointsEntity*)insertOrUpdateTotalScore:(NSDictionary*)attribute;
@end
