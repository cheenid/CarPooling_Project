//
//  MsgSenderEntity.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-2.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MsgEntity;

@interface MsgSenderEntity : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isDriver;
@property (nonatomic, retain) NSNumber * isVerifiedDriver;
@property (nonatomic, retain) NSNumber * isVerifiedPassenger;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) MsgEntity *msg;

@end
