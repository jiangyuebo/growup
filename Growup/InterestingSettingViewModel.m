//
//  InterestingSettingViewModel.m
//  Growup
//
//  Created by Jerry on 2017/4/22.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "InterestingSettingViewModel.h"
#import "globalHeader.h"
#import "BMRequestHelper.h"
#import "KidInfoModel.h"
#import "UserInfoModel.h"
#import "JerryTools.h"

@implementation InterestingSettingViewModel

- (void)setChildSetting:(NSDictionary *) settingDataDic andJumpTo:(void (^)(NSString *address)) callback{
    
    //请求地址
    NSString *url_request = [NSString stringWithFormat:@"%@%@",URL_REQUEST,URL_REQUEST_CHILD_SETTING];
    
    //请求参数
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    
    //孩子设置
    NSMutableDictionary *childDic = [NSMutableDictionary dictionary];
    //生日
    NSDate *birthday = [settingDataDic objectForKey:COLUMN_BIRTHDAY];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:birthday];
    NSString *dateParam = [NSString stringWithFormat:@"%@T00:00:00",dateStr];
    [childDic setObject:dateParam forKey:@"birthdayTS"];
    //性别
    NSNumber *sex = [settingDataDic objectForKey:COLUMN_SEX];
    [childDic setObject:sex forKey:@"sex"];
    //兴趣
    NSArray *interestsArray = [settingDataDic objectForKey:COLUMN_INTEREST];
    
    [paramsDic setObject:childDic forKey:@"child"];
    [paramsDic setObject:@"D05B01" forKey:@"educationTypeKey"];
    [paramsDic setObject:@"D06B01" forKey:@"educationRoleTypeKey"];
    [paramsDic setObject:interestsArray forKey:@"interestTypes"];
    
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper postRequestAsynchronousToUrl:url_request byParamsDic:paramsDic needAccessToken:YES andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"json Dic : %@",jsonDic);
            
            NSString *errorCode = [jsonDic objectForKey:@"errorCode"];
            NSString *errorMsg = [jsonDic objectForKey:@"errorMsg"];
            
            if (errorCode) {
                NSLog(@"errorCode:%@ , errorMsg:%@",errorCode,errorMsg);
            }else{
                //使用者信息对象
                UserInfoModel *userInfoMode = [JerryTools getUserInfoModel];
                
                
                NSDictionary *childInfoDic = [jsonDic objectForKey:@"child"];
                
                //孩子信息对象
                KidInfoModel *kidInfoMode = [[KidInfoModel alloc] init];
                
                NSString *educationRoleTypeKey = [jsonDic objectForKey:@"educationRoleTypeKey"];
                [kidInfoMode setEducationRoleTypeKey:educationRoleTypeKey];
                
                NSString *userChildID = [jsonDic objectForKey:@"userChildID"];
                [kidInfoMode setUserChildID:userChildID];
                
                NSString *educationTypeKey = [jsonDic objectForKey:@"educationTypeKey"];
                [kidInfoMode setEducationTypeKey:educationTypeKey];
                
                NSNumber *accompanyRate = [childInfoDic objectForKey:@"accompanyRate"];
                if (!accompanyRate) {
                    accompanyRate = [NSNumber numberWithInt:0];
                }
                [kidInfoMode setAccompanyRate:accompanyRate];
                
                NSNumber *accompanyTime = [childInfoDic objectForKey:@"accompanyTime"];
                if (!accompanyTime) {
                    accompanyTime = [NSNumber numberWithInt:0];
                }
                [kidInfoMode setAccompanyTime:accompanyTime];
                
                NSString *accompanyTimeValue = [childInfoDic objectForKey:@"accompanyTimeValue"];
                [kidInfoMode setAccompanyTimeValue:accompanyTimeValue];
                
                NSNumber *childId = [childInfoDic objectForKey:@"childID"];
                [kidInfoMode setChildID:childId];
                
                NSString *avatorUrl = [childInfoDic objectForKey:@"avatorUrl"];
                [kidInfoMode setAvatorUrl:avatorUrl];
                
                NSNumber *sex = [childInfoDic objectForKey:@"sex"];
                [kidInfoMode setSex:sex];
                
                NSDate *birthdayTS = [childInfoDic objectForKey:@"birthdayTS"];
                [kidInfoMode setBirthDay:birthdayTS];
                
                NSDictionary *birthday = [childInfoDic objectForKey:@"birthday"];
                [kidInfoMode setBirthdayDic:birthday];
                
                NSString *ageTypeKey = [birthday objectForKey:@"ageTypeKey"];
                [kidInfoMode setAgeTypeKey:ageTypeKey];
                
                //将孩子对象添加到使用者对象中
                if ([userInfoMode childArray]) {
                    //数组已存在
                    [[userInfoMode childArray] addObject:kidInfoMode];
                }else{
                    //数组不存在
                    NSMutableArray *childInfoArray = [[NSMutableArray alloc] init];
                    [childInfoArray addObject:kidInfoMode];
                    
                    userInfoMode.childArray = childInfoArray;
                }
                                
                callback(IdentifyNameMainViewController);
            }
        }
        
    }];
}

@end
