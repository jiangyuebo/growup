//
//  ExperienceViewModel.m
//  Growup
//
//  Created by Jerry on 2017/5/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "ExperienceViewModel.h"
#import "globalHeader.h"
#import "BMRequestHelper.h"
#import "ExperienceModel.h"

@implementation ExperienceViewModel

#pragma mark 获取体验内容列表
- (void)getExperiencesListByAgeType:(NSString *) ageType andExperienceType:(NSString *) experienceType andPageIndex:(NSNumber *) pageIndex andPageSize:(NSNumber *) pageSize andCallback:(void (^)(NSDictionary *resultDic)) callback{
    
    //api/v1/experience/getAll?ageType={ageType}&experienceType={experienceType} &pageIndex={pageIndex}&pageSize={pageSize}
    NSString *url_request = [NSString stringWithFormat:@"%@%@?ageType=%@&experienceType=%@&pageIndex=%@&pageSize=%@",URL_REQUEST,URL_REQUEST_GET_EXPERIENCE_LIST,ageType,experienceType,pageIndex,pageSize];
    
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
                [resultDic setObject:jsonDic forKey:RESULT_KEY_DATA];
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
        }
        
        callback(resultDic);
    }];
}

#pragma mark 获取体验内容明细
- (void)getExperienceDetailByID:(NSString *) experienceID andCallback:(void (^)(NSDictionary *resultDic)) callback{
    
    //api/v1/experience/get?experienceID={experienceID}
    NSString *url_request = [NSString stringWithFormat:@"%@%@?experienceID=%@",URL_REQUEST,URL_REQUEST_GET_EXPERIENCE_DETAIL,experienceID];
    
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
                [resultDic setObject:jsonDic forKey:RESULT_KEY_DATA];
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
            
        }
        
        callback(resultDic);
        
    }];
}

@end
