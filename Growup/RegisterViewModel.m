//
//  RegisterViewModel.m
//  Growup
//
//  Created by Jerry on 2017/3/23.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "RegisterViewModel.h"

#import "BMRequestHelper.h"
#import "globalHeader.h"
#import "JerryTools.h"
#import "JerryViewTools.h"
#import "UserInfoModel.h"

@implementation RegisterViewModel

#pragma mark 获取验证码
- (void)getVerifyCode:(NSString *) phoneNumber andCallback:(void (^)(NSDictionary *result)) callback{
    
    if (phoneNumber) {
        NSString *url_request = [NSString stringWithFormat:@"%@%@%@/D02B01",URL_REQUEST,URL_REQUEST_SESSION_GET_VERIFYCODE,phoneNumber];
        
        BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
        [requestHelper getRequestAsynchronousToUrl:url_request andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            
            if (data) {
                
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                NSString *errorMessage = [jsonDic objectForKey:@"errorMsg"];
                
                if (errorMessage) {
                    //有错误
                    [resultDic setObject:errorMessage forKey:RESULT_KEY_ERROR_MESSAGE];
                }else{
                    NSString *resultVerifyCode = [jsonDic objectForKey:OBSERVE_KEY_VERIFYCODE];
                    
                    if (resultVerifyCode) {
                        self.verifyCode = resultVerifyCode;
                    }
                }
            }else{
                [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
            }
            
            callback(resultDic);
        }];
    }
}

#pragma mark 用户注册
- (void)CZUserRegister:(NSString *) phoneNumber andPassword:(NSString *) password andVerifyCode:(NSString *) verifyCode andCallback:(void (^)(NSDictionary * resultDic)) callback{
    
    //请求地址
    NSString *url_request = [NSString stringWithFormat:@"%@%@",URL_REQUEST,URL_REQUEST_SESSION_REGISTER];
    
    //获取设备唯一标识
    NSString *deviceID = [JerryTools getCZDeviceId];
    
    //请求参数
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:phoneNumber forKey:@"phoneNumber"];
    [paramsDic setObject:password forKey:@"password"];
    [paramsDic setObject:verifyCode forKey:@"verifyCode"];
    [paramsDic setObject:deviceID forKey:@"deviceID"];
    [paramsDic setObject:@"D02B01" forKey:@"verifyTypeKey"];
    
    NSLog(@"注册的URL : %@",url_request);
    
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper postRequestAsynchronousToUrl:url_request byParamsDic:paramsDic needAccessToken:NO andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSString *errorCode = [jsonDic objectForKey:@"errorCode"];
            if (errorCode) {
                NSString *errorMsg = [jsonDic objectForKey:@"errorMsg"];
                NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
                [resultDic setObject:errorMsg forKey:RESULT_KEY_ERROR_MESSAGE];
                
                callback(resultDic);
            }else{
                NSString *accessToken = [jsonDic objectForKey:@"accessToken"];
                
                //保存AccessToken到本地
                [JerryTools saveInfo:accessToken name:SAVE_KEY_ACCESS_TOKEN];
                
                //设置用户数据
                NSDictionary *userDataDic = [jsonDic objectForKey:@"user"];
                //全局用户数据
                UserInfoModel *userInfo = [JerryTools getUserInfoModel];
                
                NSNumber *age = [userDataDic objectForKey:@"age"];
                [userInfo setAge:age];
                
                NSString *avatarUrl = [userDataDic objectForKey:@"avatarUrl"];
                [userInfo setAvatarUrl:avatarUrl];
                
                NSString *careerTypeKey = [userDataDic objectForKey:@"careerTypeKey"];
                [userInfo setCareerTypeKey:careerTypeKey];
                
                NSString *contactInfo = [userDataDic objectForKey:@"contactInfo"];
                [userInfo setContactInfo:contactInfo];
                
                NSString *familyAddress = [userDataDic objectForKey:@"contactInfo"];
                [userInfo setFamilyAddress:familyAddress];
                
                NSString *nickName = [userDataDic objectForKey:@"nickName"];
                [userInfo setNickName:nickName];
                
                NSString *password = [userDataDic objectForKey:@"password"];
                [userInfo setPassword:password];
                
                NSString *phoneNumber = [userDataDic objectForKey:@"phoneNumber"];
                [userInfo setPhoneNumber:phoneNumber];
                
                NSNumber *sex = [userDataDic objectForKey:@"sex"];
                [userInfo setSex:sex];
                
                NSNumber *userID = [userDataDic objectForKey:@"userID"];
                [userInfo setUserID:userID];
                
                NSString *userName = [userDataDic objectForKey:@"userName"];
                [userInfo setUserName:userName];
                
                NSString *userTypeKey = [userDataDic objectForKey:@"userTypeKey"];
                [userInfo setUserTypeKey:userTypeKey];
                
                //注册成功，跳转到设置孩子信息界面
                NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
                [resultDic setObject:IdentifyNameBirthdaySettingViewController forKey:RESULT_KEY_JUMP_PATH];
                
                callback(resultDic);
            }
        }
    }];
}

@end
