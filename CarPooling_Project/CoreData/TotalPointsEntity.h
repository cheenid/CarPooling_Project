//
//  TotalPointsEntity.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-18.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TotalPointsEntity : NSManagedObject

@property (nonatomic, retain) NSString * accountID;
@property (nonatomic, retain) NSNumber * score;

@end
