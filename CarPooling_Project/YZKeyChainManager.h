//
//  YZKeyChainManager.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-28.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZKeyChainManager : NSObject
@property (nonatomic, strong, readonly) NSString *service;

+ (YZKeyChainManager*)defaultManagerForService:(NSString*)service;
+ (YZKeyChainManager*)defaultManager;

- (id)initWithService:(NSString*)service;

- (void)setKeychainData:(NSData*)data forKey:(NSString*)key;
- (void)setKeychainValue:(NSString*)value forKey:(NSString*)key;

- (NSData*)keychainDataForKey:(NSString*)key;
- (NSString*)keychainValueForKey:(NSString*)key;

- (void)removeKeychainEntryForKey:(NSString*)key;
@end
