//
//  ScoreRecordsEntity.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-2.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ScoreRecordsEntity : NSManagedObject

@property (nonatomic, retain) NSString * mobileNo;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * recordDate;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * type;

@end
