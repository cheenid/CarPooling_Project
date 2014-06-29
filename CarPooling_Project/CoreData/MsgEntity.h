//
//  MsgEntity.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-18.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MsgEntity : NSManagedObject

@property (nonatomic, retain) NSString * accountID;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSNumber * isDriver;
@property (nonatomic, retain) NSNumber * isVerifiedDriver;
@property (nonatomic, retain) NSNumber * isVerifiedPassenger;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * msgDate;
@property (nonatomic, retain) NSString * msgID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * orderId;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * userID;

@end
