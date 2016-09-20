//
//  http_manager.m
//  
//
//  Created by max on 2016/3/30.
//  Copyright © 2016年 max. All rights reserved.
//

#import "http_manager.h"

@implementation http_manager
@synthesize _delegate;

#pragma mark -
+ (instancetype)shared
{
    static http_manager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    
    return _manager;
}

#pragma mark - 網路狀態判斷

#pragma mark 是否連線正常
+ (BOOL)isConnected
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
        
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

#pragma mark - pass value

#pragma mark 設定 request serializer
/*
 NSString *URLString = @"http://example.com";
 NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
 */
- (NSMutableURLRequest *)method_getFormatAndUrlIs:(NSString *)URLString andParameters:(NSDictionary *)parameters
{
    return [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
}

- (NSMutableURLRequest *)method_postFormatAndUrlIs:(NSString *)URLString andParameters:(NSDictionary *)parameters
{
    
    return [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
}

- (NSMutableURLRequest *)method_jsonFormatAndUrlIs:(NSString *)URLString andParameters:(NSDictionary *)parameters
{
    return [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
}

#pragma mark 傳送資料
- (void)sendDataOfRequest:(NSMutableURLRequest *)request
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        [_delegate http_finish_response:response :responseObject :error];
        
    }];
    [dataTask resume];
}

#pragma mark responseObject parse
- (NSString *)parseStr:(NSData *)responseObject
{
    return [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
}

- (id)parseJson:(NSData *)responseObject
{
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:responseObject
                 options:0
                 error:&error];
    
    if(error)
    {
        NSLog(@"解析錯誤");
    }
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *results = object;
        return results;
    }
    else if([object isKindOfClass:[NSArray class]])
    {
        NSArray *result = object;
        return result;
    }
    else
        return object;
}

#pragma mark - 上下傳檔案
- (void)downloadTask:(NSString *)urlStr
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"File downloaded to: %@", filePath);
        [_delegate http_finish_response:response :filePath :error];
    }];
    [downloadTask resume];
}


- (void)uploadTask:(NSString *)urlStr andFilePath:(NSString *)filePathStr
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:filePathStr];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [_delegate http_finish_response:response :responseObject :error];
    }];
    [uploadTask resume];
}

- (void)uploadTaskForMultiPartRequest:(NSString *)urlStr andFilePath:(NSString *)filePathStr
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePathStr] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          NSString *const progressValue = @"current_percentage";
                          [[NSNotificationCenter defaultCenter] postNotificationName:progressValue object:[NSString stringWithFormat:@"%f",uploadProgress.fractionCompleted]];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      [_delegate http_finish_response:response :responseObject :error];
                  }];
    
    [uploadTask resume];
}

@end
