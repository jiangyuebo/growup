//
//  MainPageViewModel.m
//  Growup
//
//  Created by Jerry on 2017/3/2.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "MainPageViewModel.h"
#import "globalHeader.h"
#import "BMRequestHelper.h"
#import "JerryTools.h"
#import "KidInfoModel.h"

@implementation MainPageViewModel

@synthesize userId,age,ageStr,needTest,taskCount,taskFinish,tasks,recommends,adurl;

#pragma mark 根据id获取气泡信息
- (void)queryOrangePopInfoById:(NSNumber *) childId andDynamicId:(NSNumber *) dynamicId andCallBack:(void(^)(NSDictionary * resultDic)) callback{
    
    //getDynamic?dynamicID={dynamicID}
    NSString *url_request = [NSString stringWithFormat:@"%@%@?dynamicID=%@",URL_REQUEST,URL_REQUEST_POP_GET_DYNAMIC,dynamicId];
    
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper getRequestAsynchronousToUrl:url_request andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        
        if (data) {
            
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            //判断是否NSDictionary类型
            NSString *errorCode;
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                //是
                errorCode = [jsonObject objectForKey:RESPONSE_ERROR_CODE];
            }
            
            if (errorCode) {
                //错误
                NSString *errorMsg = [jsonObject objectForKey:RESPONSE_ERROR_MSG];
                [resultDic setObject:errorMsg forKey:RESULT_KEY_ERROR_MESSAGE];
            }else{
                //无错误
                if (jsonObject) {
                    [resultDic setObject:jsonObject forKey:RESULT_KEY_DATA];
                }else{
                    NSLog(@"根据id获取气泡信息 服务器返回数据为空");
                }
            }
        }else{
            NSString *errorMessage = @"服务器异常,获取气泡数据失败";
            
            [resultDic setObject:errorMessage forKey:RESULT_KEY_ERROR_MESSAGE];
        }
        callback(resultDic);
    }];
}

#pragma mark 获取橙娃能力动态
- (void)queryChildStatusInfoByChildId:(NSNumber *) childId andAgeType:(NSString *) ageType andCallback:(void (^)(NSDictionary * resultDic)) callback{
    
    //ability/getResult/{ageType}
    NSString *url_request = [NSString stringWithFormat:@"%@%@/%@",URL_REQUEST,URL_REQUEST_CHILD_STATUS_INFO,ageType];
    
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper getRequestAsynchronousToUrl:url_request andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        
        if (data) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if (jsonDic) {
                [resultDic setObject:jsonDic forKey:RESULT_KEY_DATA];
            }else{
                NSLog(@"获取橙娃能力动态 服务器返回数据为空");
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
        }
        callback(resultDic);
    }];
    
}

#pragma mark 获取行动列表
- (void)queryActionListByAgeType:(NSString *)ageType andActionDate:(NSDate *) date andIsRefresh:(BOOL) isRefresh andCallback:(void (^)(NSDictionary * resultDic)) callback{
    
    //api/v1/user/action/getAll?ageType={ageType}&actionDate={actionDate}&isRefresh={isRefresh}
    NSString *url_request = [NSString stringWithFormat:@"%@%@?ageType=%@&actionDate=%@&isRefresh=%@",URL_REQUEST,URL_REQUEST_GET_ACTION_LIST,ageType,date,[NSNumber numberWithBool:isRefresh]];
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
                if (jsonDic) {
                    [resultDic setObject:jsonDic forKey:RESULT_KEY_DATA];
                }else{
                    NSLog(@"获取行动列表 服务器返回数据为空");
                }
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
        }
        
        callback(resultDic);
        
    }];
}

#pragma mark 提交行动项
- (void)submitActionByUserActionID:(NSNumber *)userActionID andOptionResultType:(NSString *)optionResultType andUserActionExperienceID:(NSNumber *)userActionExperienceID andUserActionTaskID:(NSNumber *)userActionTaskID andUserActionSubjectID:(NSNumber *)userActionSubjectID andCallback:(void (^)(NSDictionary * resultDic))callback{
    
    //api/v1/user/action/submit/{userActionID}/{optionResultType}?userActionExperienceID={userActionExperienceID}&userActionTaskID={userActionTaskID}&userActionSubjectID={userActionSubjectID}
    
    NSString *requestTail;
    if (userActionExperienceID) {
        requestTail = [NSString stringWithFormat:@"userActionExperienceID=%@",userActionExperienceID];
    }else if (userActionTaskID){
        requestTail = [NSString stringWithFormat:@"userActionTaskID=%@",userActionTaskID];
    }else if (userActionSubjectID){
        requestTail = [NSString stringWithFormat:@"userActionSubjectID=%@",userActionSubjectID];
    }
    
    NSString *url_request = [NSString stringWithFormat:@"%@%@/%@/%@?%@",URL_REQUEST,URL_REQUEST_SUBMIT_ACTION,userActionID,optionResultType,requestTail];
    
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
                [resultDic setObject:@"success" forKey:RESULT_KEY_DATA];
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
            
        }
        
        callback(resultDic);
        
    }];
}

#pragma mark 根据access-token获取用户及孩子信息
- (void)getUserInfoByAccesstoken:(NSString *) accesstoken andCallback:(void (^)(NSDictionary *resultDic)) callback{
    
    NSString *url_request = [NSString stringWithFormat:@"%@%@?accessToken=%@",URL_REQUEST,URL_REQUEST_GET_USER_INFO,accesstoken];
    
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
                //全局用户数据
                UserInfoModel *userInfo = [JerryTools getUserInfoModel];
                if (userInfo) {
                    //
                    NSLog(@"globle userInfo ok");
                }else{
                    NSLog(@"globle userInfo nil");
                }
                
                NSString *avatarUrl = [jsonDic objectForKey:@"avatarUrl"];
                [userInfo setAvatarUrl:avatarUrl];
                
                NSDate *birthdayTS = [jsonDic objectForKey:@"birthdayTS"];
                [userInfo setBirthdayTS:birthdayTS];
                
                NSString *contactInfo = [jsonDic objectForKey:@"contactInfo"];
                [userInfo setContactInfo:contactInfo];
                
                NSString *familyAddress = [jsonDic objectForKey:@"familyAddress"];
                [userInfo setFamilyAddress:familyAddress];
                
                NSString *nickName = [jsonDic objectForKey:@"nickName"];
                [userInfo setNickName:nickName];
                
                NSString *password = [jsonDic objectForKey:@"password"];
                [userInfo setPassword:password];
                
                NSString *phoneNumber = [jsonDic objectForKey:@"phoneNumber"];
                [userInfo setPhoneNumber:phoneNumber];
                
                NSNumber *userID = [jsonDic objectForKey:@"userID"];
                [userInfo setUserID:userID];
                
                NSString *userName = [jsonDic objectForKey:@"userName"];
                [userInfo setUserName:userName];
                
                NSString *userTypeKey = [jsonDic objectForKey:@"userTypeKey"];
                [userInfo setUserTypeKey:userTypeKey];
                
                //设置默认选择第一个孩子
                [userInfo setCurrentSelectedChild:0];
                
                //获取孩子信息
                NSArray *childArray = [jsonDic objectForKey:@"userChild"];
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
                    
                    NSString *ageTypeKey = [birthday objectForKey:@"ageTypeKey"];
                    [kidInfoMode setAgeTypeKey:ageTypeKey];
                    
                    [childInfoArray addObject:kidInfoMode];
                }
                
                [userInfo setChildArray:childInfoArray];
                
                //完成
                [resultDic setObject:@"success" forKey:RESULT_KEY_DATA];
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
            
        }
        
        callback(resultDic);
    }];
}

#pragma mark 根据access-token获取用户及孩子信息DIC
- (void)getUserInfoDicByAccesstoken:(NSString *) accesstoken andCallback:(void (^)(NSDictionary *resultDic)) callback{
    NSString *url_request = [NSString stringWithFormat:@"%@%@?accessToken=%@",URL_REQUEST,URL_REQUEST_GET_USER_INFO,accesstoken];
    
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
                //完成
                if (jsonDic) {
                    [resultDic setObject:jsonDic forKey:RESULT_KEY_DATA];
                }
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
        }
        
        callback(resultDic);
    }];
}

@end
