//
//  PersonalData.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-18.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PersonalData : NSManagedObject

@property (nonatomic, retain) NSString * accountID;
@property (nonatomic, retain) NSString * backPhoto;
@property (nonatomic, retain) NSNumber * birthday;
@property (nonatomic, retain) NSString * carColor;
@property (nonatomic, retain) NSString * carLicencesPhoto;
@property (nonatomic, retain) NSString * carNumber;
@property (nonatomic, retain) NSString * carType;
@property (nonatomic, retain) NSString * driverLicencesPhoto;
@property (nonatomic, retain) NSString * frontPhoto;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * headPhoto;
@property (nonatomic, retain) NSNumber * isAuthedCar;
@property (nonatomic, retain) NSNumber * isAuthedDriver;
@property (nonatomic, retain) NSNumber * isAuthedHead;
@property (nonatomic, retain) NSNumber * isAuthedIdentity;
@property (nonatomic, retain) NSNumber * isDriver;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * realname;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * carSeats;

@end
