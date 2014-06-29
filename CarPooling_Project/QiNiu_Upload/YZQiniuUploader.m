//
//  YZQiniuUploader.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-15.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZQiniuUploader.h"

#define kQiniuUpUploadUrl @"http://up.qiniu.com"

@implementation YZQiniuFile

- (instancetype)initWithFileData:(NSData *)theData
{
    return [self initWithFileData:theData withKey:nil mimeType:@"image/png"];
}

- (instancetype)initWithFileData:(NSData *)theData
                         withKey:(NSString *)theKey
                        mimeType:(NSString *)theMimeType
{
    self = [super init];
    if (self)
    {
        self.fileData = theData;
        self.key = theKey;
        self.mimeType = theMimeType;
    }
    return self;
}
@end

#pragma mark -
#pragma mark 七牛上传

@interface YZQiniuUploader()
@property (nonatomic, copy) oneFileUploadSuccess uploadSuccess;
@property (nonatomic, copy) oneFileUploadFailture uploadFailture;
@property (nonatomic, copy) oneFileProgress uploadProgress;
@property (nonatomic, copy) uploadAllFilesComplete uploadComplete;
@end

@implementation YZQiniuUploader

- (void)execuploadTask:(oneFileUploadSuccess)uploadSuccess
 oneFileUploadFailture:(oneFileUploadFailture)uploadFailture
       oneFileProgress:(oneFileProgress)uploadProgress
uploadAllFilesComplete:(uploadAllFilesComplete)uploadAllFilesComplete
{
    _uploadSuccess = uploadSuccess;
    _uploadFailture = uploadFailture;
    _uploadProgress = uploadProgress;
    _uploadComplete = uploadAllFilesComplete;
}

- (id)init
{
    return [self initWithToken:nil];
}

- (id)initWithToken:(QiniuPutPolicy *)theToken
{
    if (self = [super init])
    {
        self.files = [[NSMutableArray alloc] init];
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount:1];
        self.token = theToken;
    }
    return self;
}

- (void)addFile:(YZQiniuFile *)file
{
    [self.files addObject:file];
}

- (NSInteger)fileCount
{
    return self.files.count;
}

- (void)addFiles:(NSArray *)theFiles
{
    [self.files addObjectsFromArray:theFiles];
}

- (Boolean)startUpload
{
    if (!self.files)
    {
        return NO;
    }
    NSOperation *operation = [[NSOperation alloc] init];
    [self.operationQueue addOperation:operation];
    
    for (NSInteger i = 0; i < self.files.count; i++)
    {
        AFHTTPRequestOperation *theOperation = [self QiniuOperation:i];
        [theOperation addDependency:operation];
        [self.operationQueue addOperation:theOperation];
        operation = theOperation;
    }
    return YES;
}

- (Boolean)cancelAllUploadTask
{
    if (self.operationQueue.operations.count == 0)
    {
        return NO;
    }
    [self.operationQueue cancelAllOperations];
    return YES;
}


- (AFHTTPRequestOperation*)QiniuOperation:(NSInteger)index
{
    YZQiniuFile *theFile = self.files[index];
    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kQiniuUpUploadUrl]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (theFile.key)
    {
        parameters[@"key"] = theFile.key;
    }
    parameters[@"token"] = [self.token makeToken:KQiniuAccessKey secretKey:KQiniuSecretKey];
    
    NSMutableURLRequest *request = [operationManager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:kQiniuUpUploadUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:theFile.fileData
                                    name:@"file"
                                fileName:@"file"
                                mimeType:theFile.mimeType];
    } error:nil];
    
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DEBUG_METHOD(@"---responseObject---%@",responseObject);
        if ([self.delegate respondsToSelector:@selector(uploadOneFileSucceeded:Index:ret:)])
        {
            [self.delegate uploadOneFileSucceeded:operation Index:index ret:responseObject];
        }
        
        if (_uploadSuccess)
        {
            _uploadSuccess(operation,index,responseObject);
        }
        
        if (index == self.files.count -1)
        {
            [self.delegate uploadAllFilesComplete];
        }
        
        if (_uploadComplete)
        {
            _uploadComplete();
        }

    };
    
    void (^failtureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if ([self.delegate respondsToSelector:@selector(uploadOneFileFailed:Index:error:)])
        {
            [self.delegate uploadOneFileFailed:operation Index:index error:error];
        }
        if (_uploadFailture)
        {
            _uploadFailture(operation,index,error);
        }
    };
    
    AFHTTPRequestOperation *operation = [operationManager HTTPRequestOperationWithRequest:request
                                                                                  success:successBlock
                                                                                  failure:failtureBlock];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
        double percent = (double)totalBytesWritten / totalBytesExpectedToWrite;
        if ([self.delegate respondsToSelector:@selector(uploadOneFileProgress:UploadPercent:)])
        {
            [self.delegate uploadOneFileProgress:index UploadPercent:percent];
        }
         if (_uploadProgress)
         {
             _uploadProgress(index,percent);
         }
    }];
    return operation;
}

@end
