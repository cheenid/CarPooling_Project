//
//  CPASIHttpRequest.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-18.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASIHTTPRequest.h>
#import <ASIFormDataRequest.h>

@interface CPASIHttpRequest : NSObject
+ (instancetype)shared;
- (ASIFormDataRequest*)requestLoginOrRegister:(NSString*)mobile
                                         code:(NSString*)code
                                      success:(void(^)(id responseObject))success
                                     failture:(void(^)(NSError *error))failture;

- (ASIFormDataRequest*)requestAutoLogin:(NSString*)mobile
                               password:(NSString*)password
                                success:(void(^)(id responseObject))success
                               failture:(void(^)(NSError *error))failture;
@end
