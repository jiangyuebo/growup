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
#import "KidInfoModel.h"

@implementation LoginViewModel

- (void)userLoginByUserName:(NSString *) userName andPassword:(NSString *) password callback:(void (^)(NSDictionary * resultDic)) callback{
    
    if (userName && password) {
        
        NSString *url_request = [NSString stringWithFormat:@"%@%@",URL_REQUEST,URL_REQUEST_SESSION_LOGIN];
        
        NSLog(@"登录的请求 url:%@",url_request);
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
            
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            
            if (data) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                NSString *errorCode = [jsonDic objectForKey:@"errorCode"];
                
                if (errorCode) {
                    //服务器错误
                    NSString *errorMsg = [jsonDic objectForKey:@"errorMsg"];
                    [resultDic setObject:errorMsg forKey:RESULT_KEY_ERROR_MESSAGE];
                }else{
                    NSString *accessToken = [jsonDic objectForKey:@"accessToken"];
                    
                    //保存AccessToken到本地
                    [JerryTools saveInfo:accessToken name:SAVE_KEY_ACCESS_TOKEN];
                    
                    //设置用户数据
                    NSDictionary *userDataDic = [jsonDic objectForKey:@"user"];
                    //全局用户数据
                    UserInfoModel *userInfo = [JerryTools getUserInfoModel];
                    
                    NSString *avatarUrl = [userDataDic objectForKey:@"avatarUrl"];
                    [userInfo setAvatarUrl:avatarUrl];
                    
                    NSDate *birthdayTS = [userDataDic objectForKey:@"birthdayTS"];
                    [userInfo setBirthdayTS:birthdayTS];
                    
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
                    
                    NSNumber *userID = [userDataDic objectForKey:@"userID"];
                    [userInfo setUserID:userID];
                    
                    NSString *userName = [userDataDic objectForKey:@"userName"];
                    [userInfo setUserName:userName];
                    
                    NSString *userTypeKey = [userDataDic objectForKey:@"userTypeKey"];
                    [userInfo setUserTypeKey:userTypeKey];
                    
                    //设置默认选择第一个孩子
                    [userInfo setCurrentSelectedChild:0];
                    
                    //获取孩子信息
                    NSArray *childArray = [userDataDic objectForKey:@"userChild"];
                    //用来存储孩子信息的ARRAY
                    NSMutableArray *childInfoArray = [[NSMutableArray alloc] init];
                    
                    for (int i = 0; i < [childArray count]; i++) {
                        KidInfoModel *kidInfoMode = [[KidInfoModel alloc] init];
                        
                        NSDictionary *childModeInfo = [childArray objectAtIndex:i];
                        NSString *educationRoleTypeKey = [childModeInfo objectForKey:@"educationRoleTypeKey"];
                        [kidInfoMode setEducationRoleTypeKey:educationRoleTypeKey];
                        
                        NSString *educationTypeKey = [childModeInfo objectForKey:@"educationTypeKey"];
                        [kidInfoMode setEducationTypeKey:educationTypeKey];
                        
                        NSNumber *accompanyRate = [childModeInfo objectForKey:@"accompanyRate"];
                        [kidInfoMode setAccompanyRate:accompanyRate];
                        
                        NSNumber *accompanyTime = [childModeInfo objectForKey:@"accompanyTime"];
                        [kidInfoMode setAccompanyTime:accompanyTime];
                        
                        NSDictionary *childInfo = [childModeInfo objectForKey:@"child"];
                        
                        NSNumber *childId = [childInfo objectForKey:@"childID"];
                        [kidInfoMode setChildID:childId];
                        
                        NSString *avatorUrl = [childInfo objectForKey:@"avatorUrl"];
                        [kidInfoMode setAvatorUrl:avatorUrl];
                        
                        NSNumber *sex = [childInfo objectForKey:@"sex"];
                        [kidInfoMode setSex:sex];
                        
                        NSDate *birthdayTS = [childInfo objectForKey:@"birthdayTS"];
                        [kidInfoMode setBirthDay:birthdayTS];
                        
                        NSDictionary *birthday = [childInfo objectForKey:@"birthday"];
                        [kidInfoMode setBirthdayDic:birthday];
                        
                        NSNumber *age = [childInfo objectForKey:@"age"];
                        [kidInfoMode setAge:age];
                        
                        NSString *ageTypeKey = [birthday objectForKey:@"ageTypeKey"];
                        [kidInfoMode setAgeTypeKey:ageTypeKey];
                        
                        [childInfoArray addObject:kidInfoMode];
                    }
                    
                    [userInfo setChildArray:childInfoArray];
                    
                    //成功，跳转到首页
                    [resultDic setObject:IdentifyNameMainViewController forKey:RESULT_KEY_JUMP_PATH];
                }
            }else{
                //返回数据为空
                [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
                
            }
            
            callback(resultDic);
        }];
    }
}

@end
