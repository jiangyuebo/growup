//
//  LoginViewModel.m
//  Growup
//
//  Created by Jerry on 2017/4/21.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "LoginViewModel.h"
#import "globalHeader.h"
#import "BMRequestHelper.h"
#import "JerryTools.h"

@implementation LoginViewModel

- (void)userLoginByUserName:(NSString *) userName andPassword:(NSString *) password{
    
    if (userName && password) {
        
        NSString *url_request = [NSString stringWithFormat:@"%@%@",URL_REQUEST,URL_REQUEST_SESSION_LOGIN];
        
        //设备唯一标识
        NSString *deviceId = [JerryTools getCZDeviceId];
        
        //请求参数
        NSDictionary *paramsDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   userName,@"phoneNumber",
                                   password,@"password",
                                   deviceId,@"deviceID",
                                   nil];
        
        BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
        [requestHelper postRequestAsynchronousToUrl:url_request byParamsDic:paramsDic needAccessToken:NO andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (data) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"json Dic : %@",jsonDic);
            }
        }];
    }
}

@end
