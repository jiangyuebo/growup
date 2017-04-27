//
//  BMRequestHelper.m
//  BMVehicleControl
//
//  Created by Jerry on 2017/1/4.
//  Copyright © 2017年 BanMa. All rights reserved.
//

#import "BMRequestHelper.h"
#import "JerryTools.h"

@implementation BMRequestHelper

- (void)postRequestAsynchronousToUrl:(NSString *) url byParamsStr:(NSString *)paramsStr andCallback:(void (^)(NSData *data,NSURLResponse *response,NSError *error)) callback{
    
    NSURL *postUrl = [NSURL URLWithString:url];
    
    //date=20151031&startRecord=1&len=5
    NSData *postData = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    //设置请求方式
    request.HTTPMethod = @"POST";
    //设置请求参数
    request.HTTPBody = postData;
    //创建会话对象
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    //发送请求
    NSURLSessionDataTask *postTask = [urlSession dataTaskWithRequest:request
                                               completionHandler:^(
                                                                   NSData * _Nullable data,
                                                                   NSURLResponse * _Nullable response,
                                                                   NSError * _Nullable error) {
                                                   callback(data,response,error);
    }];
    
    //执行任务
    [postTask resume];
    
}

//post异步请求方法
- (void)postRequestAsynchronousToUrl:(NSString *) url byParamsDic:(NSDictionary *)paramsDic needAccessToken:(BOOL) isNeed andCallback:(void (^)(NSData *data,NSURLResponse *response,NSError *error)) callback{
    
    NSURL *postUrl = [NSURL URLWithString:url];
    
    NSError *error;
    
    //DIC 转 JSON
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDic options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"Error : %@",error);
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    //application/json
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //是否需要access token
    if (isNeed) {
        NSString *accessToken = [JerryTools getAccessToken];
        [request addValue:accessToken forHTTPHeaderField:@"ACCESS-TOKEN"];
    }
    
    //设置请求方式
    request.HTTPMethod = @"POST";
    //设置请求参数
    request.HTTPBody = jsonData;
    //创建会话对象
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    //发送请求
    NSURLSessionDataTask *postTask = [urlSession dataTaskWithRequest:request
                                                   completionHandler:^(
                                                                       NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error) {
                                                       callback(data,response,error);
                                                   }];
    
    //执行任务
    [postTask resume];
}

- (void)getRequestAsynchronousToUrl:(NSString *) url andCallback:(void (^)(NSData *data,NSURLResponse *response,NSError *error)) callback{
    
    NSURL *getUrl = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    NSLog(@"REQUEST URL : %@",getUrl);
    
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:getUrl];
    
    NSString *accessToken = [JerryTools getAccessToken];
    if (accessToken) {
        [request addValue:accessToken forHTTPHeaderField:@"ACCESS-TOKEN"];
    }
    
    //创建会话对象
    NSURLSession *urlSession = [NSURLSession sharedSession];
    //发送请求
    NSURLSessionDataTask *getTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //NSData --> NSString
        NSString *receiveStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSString --> NSData
        NSData *tempData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        
        callback(tempData,response,error);
    }];
    
    [getTask resume];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    //    if([challenge.protectionSpace.host isEqualToString:@"api.lz517.me"] /*check if this is host you trust: */ ){
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

@end
