//
//  QiniuAuthPolicy.h
//  QiniuSDK
//
//  Created by Qiniu Developers 2013
//

#import <Foundation/Foundation.h>

#define KQiniuScope @"share9car27t"

// NOTE: Generally speaking, this class is not required for client development.
// The token string should be retrieved from your biz server.

// Refer to the spec: http://docs.qiniu.com/api/put.html#uploadToken
@interface QiniuPutPolicy : NSObject

@property (retain, nonatomic) NSString *scope;
@property (retain, nonatomic) NSString *callbackUrl;
@property (retain, nonatomic) NSString *callbackBody;
@property (retain, nonatomic) NSString *returnUrl;
@property (retain, nonatomic) NSString *returnBody;
@property (retain, nonatomic) NSString *asyncOps;
@property (retain, nonatomic) NSString *endUser;
@property (nonatomic, assign) int expires;

- (NSString*)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey;

@end

@interface QiniuToken : NSObject
@property (copy, nonatomic) NSString *secretKey;
@property (copy, nonatomic) NSString *accessKey;
@property (copy, nonatomic) NSString *scope;
- (NSString *)uploadToken;
- (id)initWithScope:(NSString *)theScope SecretKey:(NSString*)theSecretKey Accesskey:(NSString*)theAccessKey;
@end
