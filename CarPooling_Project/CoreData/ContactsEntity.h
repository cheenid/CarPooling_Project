//
//  ContactsEntity.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-2.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContactsEntity : NSManagedObject

@property (nonatomic, retain) NSString * headPhoto;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isAuthedCar;
@property (nonatomic, retain) NSNumber * isAuthedDriver;
@property (nonatomic, retain) NSNumber * isAuthedHead;
@property (nonatomic, retain) NSNumber * isAuthedIdentity;
@property (nonatomic, retain) NSNumber * isDriver;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;

@end
