//
//  CPASIHttpRequest.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-18.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "CPASIHttpRequest.h"
#import <JSONKit.h>

@implementation CPASIHttpRequest
+ (instancetype)shared
{
    static dispatch_once_t pred;
    static CPASIHttpRequest *httpRequest = nil;
    dispatch_once(&pred, ^{ httpRequest = [[self alloc] init]; });
    return httpRequest;
}

- (ASIFormDataRequest*)requestLoginOrRegister:(NSString*)mobile
                                         code:(NSString*)code
                                      success:(void(^)(id responseObject))success
                                     failture:(void(^)(NSError *error))failture
{
    NSURL *url = [NSURL URLWithString:@"http://www.egoal.cn/sharecar/api/login/sms"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *requestBlock = request;
    [request setPostValue:mobile    forKey:@"mobile"];
    [request setPostValue:code      forKey:@"code"];
    [request setCompletionBlock:^{
        NSData *jsonData = [requestBlock responseData];
        id responseObject = [jsonData objectFromJSONData];
        success(responseObject);
    }];
    [request setFailedBlock:^{
        NSError *error = [requestBlock error];
        failture(error);
    }];
    [request startSynchronous];
    return request;
}

- (ASIFormDataRequest*)requestAutoLogin:(NSString*)mobile
                               password:(NSString*)password
                                success:(void(^)(id responseObject))success
                               failture:(void(^)(NSError *error))failture
{
    NSURL *url = [NSURL URLWithString:@"http://www.egoal.cn/sharecar/api/login/password"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *requestBlock = request;
    [request setPostValue:mobile    forKey:@"mobile"];
    [request setPostValue:password      forKey:@"password"];
    [request setCompletionBlock:^{
        NSData *jsonData = [requestBlock responseData];
        id responseObject = [jsonData objectFromJSONData];
        success(responseObject);
    }];
    [request setFailedBlock:^{
        NSError *error = [requestBlock error];
        failture(error);
    }];
    [request startSynchronous];
    return request;

}
@end
