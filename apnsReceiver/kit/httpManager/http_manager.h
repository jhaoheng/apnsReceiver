//
//  http_manager.h
//  
//
//  Created by max on 2016/3/30.
//  Copyright © 2016年 max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/*
 將連線回傳值返回的 delegate
 */
@protocol httpFinishDelegate

-(void)http_finish_response:(NSURLResponse *)response :(id)responseObject :(NSError *)error;

@end

@interface http_manager : NSObject
{
    NSObject<httpFinishDelegate> *_delegate;
}
@property (nonatomic, retain) NSObject<httpFinishDelegate> *_delegate;

+ (instancetype)shared;

#pragma mark - 檢查連線狀態
+ (BOOL)isConnected;

/*
 設定 request serializer
 */
- (NSMutableURLRequest *)method_getFormatAndUrlIs:(NSString *)URLString andParameters:(NSDictionary *)parameters;

- (NSMutableURLRequest *)method_postFormatAndUrlIs:(NSString *)URLString andParameters:(NSDictionary *)parameters;

- (NSMutableURLRequest *)method_jsonFormatAndUrlIs:(NSString *)URLString andParameters:(NSDictionary *)parameters;

#pragma mark - 建立連線:傳送資料
- (void)sendDataOfRequest:(NSMutableURLRequest *)request;

#pragma mark - 回傳參數解析 : responseObject parse
- (NSString *)parseStr:(NSData *)responseObject;
- (id)parseJson:(NSData *)responseObject;

#pragma mark - 上下傳物件
/*
 FilePath :file://path/to/image.png
 */

//下載
- (void)downloadTask:(NSString *)urlStr;


// 上傳
- (void)uploadTask:(NSString *)urlStr andFilePath:(NSString *)filePathStr;
- (void)uploadTaskForMultiPartRequest:(NSString *)urlStr andFilePath:(NSString *)filePathStr;
extern NSString *const progressValue;
/*
 要使用的頁面放入
 
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(test:) name:progressValue object:nil];
 
 - (void)test:(NSNotification *)sender
 {
     NSLog(@"%@",sender.name);
     NSLog(@"%@",sender.object);
 }
 */
@end
