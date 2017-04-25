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

@implementation InterestingSettingViewModel

- (void)setChildSetting:(NSDictionary *) settingDataDic andJumpTo:(void (^)(NSString *address)) callbak{
    
    //请求地址
        NSString *url_request = [NSString stringWithFormat:@"%@%@",URL_REQUEST,URL_REQUEST_SESSION_REGISTER];
    //TEST
//    NSString *url_request = [NSString stringWithFormat:@"%@%@",URL_TEST_REQUEST,URL_REQUEST_CHILD_SETTING];
    
    //请求参数
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    
    //孩子设置
    NSMutableDictionary *childDic = [NSMutableDictionary dictionary];
    //生日
    NSDate *birthday = [settingDataDic objectForKey:COLUMN_BIRTHDAY];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:birthday];
    [childDic setObject:dateStr forKey:@"birthday"];
    //性别
    NSNumber *sex = [settingDataDic objectForKey:COLUMN_SEX];
    [childDic setObject:sex forKey:@"sex"];
    
    [paramsDic setObject:childDic forKey:@"child"];
    [paramsDic setObject:@"D05B01" forKey:@"educationTypeKey"];
    [paramsDic setObject:@"D06B01" forKey:@"educationRoleTypeKey"];
    
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper postRequestAsynchronousToUrl:url_request byParamsDic:paramsDic needAccessToken:YES andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"json Dic : %@",jsonDic);
            
            NSString *errorCode = [jsonDic objectForKey:@"errorCode"];
            NSString *errorMsg = [jsonDic objectForKey:@"errorMsg"];
            
            NSLog(@"errorCode:%@ , errorMsg:%@",errorCode,errorMsg);
        }
        
    }];
}

@end
