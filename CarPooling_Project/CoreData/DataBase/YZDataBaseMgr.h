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
#import "CreateNodesEntity.h"
#import "CreateRouteEntity.h"

@interface YZDataBaseMgr : IQDatabaseManager

// personalData
- (NSManagedObject*)fetchPersonalData;
- (void)insertOrUpdatePersonalData:(NSDictionary*)attribute
                          complete:(void(^)(NSManagedObject *object,BOOL ret))result;

// totalScore
- (TotalPointsEntity*)fetchTotalScore;
- (void)insertOrUpdateTotalScore:(NSDictionary*)attribute
                        complete:(void(^)(TotalPointsEntity *object,BOOL ret))result;

- (void)insertOrUpdateCtRoute:(NSDictionary*)attribute
                     complete:(void(^)(NSManagedObject *object,BOOL ret))result;
@end
