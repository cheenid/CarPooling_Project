//
//  CreateRouteEntity.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-2.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CreateRouteEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * personType;
@property (nonatomic, retain) NSNumber * routeType;
@property (nonatomic, retain) NSString * leaveTime;
@property (nonatomic, retain) NSString * leaveDate;
@property (nonatomic, retain) NSString * backTime;
@property (nonatomic, retain) NSNumber * seat;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * repeat;
@property (nonatomic, retain) NSSet *nodes;
@end

@interface CreateRouteEntity (CoreDataGeneratedAccessors)

- (void)addNodesObject:(NSManagedObject *)value;
- (void)removeNodesObject:(NSManagedObject *)value;
- (void)addNodes:(NSSet *)values;
- (void)removeNodes:(NSSet *)values;

@end
