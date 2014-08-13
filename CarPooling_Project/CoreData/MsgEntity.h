//
//  MsgEntity.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-2.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MsgSenderEntity;

@interface MsgEntity : NSManagedObject

@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * msgDate;
@property (nonatomic, retain) NSString * orderId;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) MsgSenderEntity *msgSender;

@end
