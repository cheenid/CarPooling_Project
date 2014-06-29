//
//  QiniuAuthPolicy.m
//  QiniuSDK
//
//  Created by Qiniu Developers 2013
//

#import "QiniuPutPolicy.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import <JSONKit/JSONKit.h>

@implementation QiniuPutPolicy

@synthesize scope;
@synthesize callbackUrl;
@synthesize callbackBody;
@synthesize returnUrl;
@synthesize returnBody;
@synthesize asyncOps;
@synthesize endUser;
@synthesize expires;

// Make a token string conform to the UpToken spec.

- (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey
{
	NSString *policy = [self marshal];
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedPolicy = [GTMBase64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    const char *secretKeyStr = [secretKey UTF8String];
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    NSString *encodedDigest = [GTMBase64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
	return token;
}

// Marshal as JSON format string.

- (NSString *)marshal
{
    time_t deadline;
    time(&deadline);
    deadline += (self.expires > 0) ? self.expires : 3600; // 1 hour by default.
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.scope)
    {
        [dic setObject:self.scope forKey:@"scope"];
    }
    if (self.callbackUrl)
    {
        [dic setObject:self.callbackUrl forKey:@"callbackUrl"];
    }
    if (self.callbackBody) {
        [dic setObject:self.callbackBody forKey:@"callbackBody"];
    }
    if (self.returnUrl) {
        [dic setObject:self.returnUrl forKey:@"returnUrl"];
    }
    if (self.returnBody) {
        [dic setObject:self.returnBody forKey:@"returnBody"];
    }
    if (self.endUser) {
        [dic setObject:self.endUser forKey:@"endUser"];
    }
    [dic setObject:deadlineNumber forKey:@"deadline"];
    
    NSString *json = [dic JSONString];
    return json;
}

@end

@implementation QiniuToken

- (id)initWithScope:(NSString *)theScope SecretKey:(NSString*)theSecretKey Accesskey:(NSString*)theAccessKey
{
    if (self = [super init])
    {
        self.scope = theScope;
        self.secretKey = theSecretKey;
        self.accessKey = theAccessKey;
    }
    return self;
}

- (NSString *)uploadToken
{
    NSMutableDictionary *authInfo = [[NSMutableDictionary alloc]init];
    [authInfo setObject:@"share9car27t" forKey:@"scope"];
    [authInfo setObject:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]+300] forKey:@"deadline" ];
    //    [authInfo setObject:@"" forKey:@"callbackUrl"];
    //    [authInfo setObject:@"" forKey:@"callbackBodyType"];
    //    [authInfo setObject:@"" forKey:@"customer"];
    //    [authInfo setObject:@"" forKey:@"escape"];
    //    [authInfo setObject:@"" forKey:@"asyncOps"];
    //    [authInfo setObject:@"" forKey:@"returnBody"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authInfo
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *authInfoEncoded = [self urlSafeBase64Encode:jsonData];
    NSString *authDigestEncoded = [self hmac_sha1:_secretKey text:authInfoEncoded];
    
    return [NSString stringWithFormat:@"%@:%@:%@",_accessKey,authDigestEncoded,authInfoEncoded];
}


- (NSString *)hmac_sha1:(NSString *)key text:(NSString *)text{
    
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [self urlSafeBase64Encode:HMAC];
    return hash;
}

- (NSString *)urlSafeBase64Encode:(NSData *)text
{
    NSString *base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:text]
                                             encoding:NSUTF8StringEncoding];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return base64;
}

- (NSString *)encodedEntryURI:(NSString*)entry
{
    
    return [self urlSafeBase64Encode:[[NSString stringWithFormat:@"share9car27t:%@", [self encryptMD5String:entry]] dataUsingEncoding:NSUTF8StringEncoding]];
}

-(NSString*)encryptMD5String:(NSString*)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


@end