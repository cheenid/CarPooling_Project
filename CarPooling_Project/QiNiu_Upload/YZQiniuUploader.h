//
//  YZQiniuUploader.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-15.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "QiniuPutPolicy.h"



typedef void(^oneFileUploadSuccess) (AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *ret);
typedef void(^oneFileUploadFailture) (AFHTTPRequestOperation *operation, NSInteger index, NSError *error);
typedef void(^oneFileProgress) (NSInteger index, double percent);
typedef void(^uploadAllFilesComplete)();

static  NSString  *KQiniuAccessKey = @"Z8JqT2tLulEVpx0XScaU6lALuz2_PZLinfSONfko";
static  NSString  *KQiniuSecretKey = @"fUy4T6sT5RyanSE8FS5uHJbkBEBcJ4mPKSp4d7Fg";


@protocol QiniuUploaderDelegate <NSObject>
@optional
- (void)uploadOneFileSucceeded:(AFHTTPRequestOperation *)operation Index:(NSInteger)index ret:(NSDictionary *)ret;
- (void)uploadOneFileFailed:(AFHTTPRequestOperation *)operation Index:(NSInteger)index error:(NSError *)error;
- (void)uploadOneFileProgress:(NSInteger)index UploadPercent:(double)percent;
@required
- (void)uploadAllFilesComplete;
@end


@interface YZQiniuFile : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, copy) NSData *fileData;

- (instancetype)initWithFileData:(NSData*)theData;
- (instancetype)initWithFileData:(NSData *)theData withKey:(NSString*)theKey mimeType:(NSString*)theMimeType;
@end


@interface YZQiniuUploader : NSObject
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) QiniuPutPolicy *token;
@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, unsafe_unretained) id<QiniuUploaderDelegate> delegate;

- (id)initWithToken:(QiniuPutPolicy *)theToken;
- (void)addFile:(YZQiniuFile *)file;
- (void)addFiles:(NSArray *)theFiles;
- (Boolean)startUpload;
- (Boolean)cancelAllUploadTask;
- (NSInteger)fileCount;
- (void)execuploadTask:(oneFileUploadSuccess)uploadSuccess
 oneFileUploadFailture:(oneFileUploadFailture)uploadFailture
       oneFileProgress:(oneFileProgress)uploadProgress
uploadAllFilesComplete:(uploadAllFilesComplete)uploadAllFilesComplete;

@end
