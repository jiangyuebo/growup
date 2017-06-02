//
//  CZPersonCenterViewModel.m
//  Growup
//
//  Created by Jerry on 2017/6/2.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZPersonCenterViewModel.h"
#import "BMRequestHelper.h"
#import "globalHeader.h"

@implementation CZPersonCenterViewModel

#pragma mark 修改用户信息
- (void)changeUserInfo:(NSMutableDictionary *) userInfoDic andCallback:(void (^)(NSDictionary * resultDic)) callback{
    
    NSString *url_request = [NSString stringWithFormat:@"%@%@",URL_REQUEST,URL_USER_UPDATE];
    
    NSLog(@"修改用户信息的请求 url:%@",url_request);
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper postRequestAsynchronousToUrl:url_request byParamsDic:userInfoDic needAccessToken:YES andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        
        if (data) {
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSString *errorMessage = [jsonDic objectForKey:@"errorMsg"];
            
            if (errorMessage) {
                //有错误
                [resultDic setObject:errorMessage forKey:RESULT_KEY_ERROR_MESSAGE];
            }else{
                //修改成功
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_REFRESH_USER_INFO object:nil];
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
        }
        
        callback(resultDic);
        
    }];
}

@end
