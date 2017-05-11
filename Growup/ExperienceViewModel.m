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
                
                if ([experienceType isEqualToString:EXPERIENCE_GAME]) {
                    NSArray *experiences = [jsonDic objectForKey:@"experiences"];
                    
                    NSMutableArray *experiencesResultArray = [[NSMutableArray alloc] init];
                    
                    for (int i = 0; i < [experiences count]; i++) {
                        ExperienceModel *experienceModel = [[ExperienceModel alloc] init];
                        
                        NSDictionary *expericence = experiences[i];
                        
                        NSString *ageTypeKey = [expericence objectForKey:@"ageTypeKey"];
                        [experienceModel setAgeTypeKey:ageTypeKey];
                        
                        NSString *contentResourceTypeKey = [expericence objectForKey:@"contentResourceTypeKey"];
                        [experienceModel setContentResourceTypeKey:contentResourceTypeKey];
                        
                        NSString *contentResourceUrl = [expericence objectForKey:@"contentResourceUrl"];
                        [experienceModel setContentResourceUrl:contentResourceUrl];
                        
                        NSString *experienceBrief = [expericence objectForKey:@"experienceBrief"];
                        [experienceModel setExperienceBrief:experienceBrief];
                        
                        NSString *experienceDescription = [expericence objectForKey:@"experienceDescription"];
                        [experienceModel setExperienceDescription:experienceDescription];
                        
                        NSNumber *experienceID = [expericence objectForKey:@"experienceID"];
                        [experienceModel setExperienceID:experienceID];
                        
                        NSString *experienceName = [expericence objectForKey:@"experienceName"];
                        [experienceModel setExperienceName:experienceName];
                        
                        NSString *experienceTypeKey = [expericence objectForKey:@"experienceTypeKey"];
                        [experienceModel setExperienceTypeKey:experienceTypeKey];
                        
                        NSString *experienceUseTypeKey = [expericence objectForKey:@"experienceUseTypeKey"];
                        [experienceModel setExperienceUseTypeKey:experienceUseTypeKey];
                        
                        NSString *logoResourceTypeKey = [expericence objectForKey:@"logoResourceTypeKey"];
                        [experienceModel setLogoResourceTypeKey:logoResourceTypeKey];
                        
                        NSString *logoResourceUrl = [expericence objectForKey:@"logoResourceUrl"];
                        [experienceModel setLogoResourceUrl:logoResourceUrl];
                        
                        [experiencesResultArray addObject:experienceModel];
                        
                        [resultDic setObject:experiencesResultArray forKey:RESULT_KEY_DATA];
                    }
                }
                
                if ([experienceType isEqualToString:EXPERIENCE_SCIENCE]) {
                    
                    NSArray *experiences = [jsonDic objectForKey:@"experiences"];
                    
                    NSMutableArray *experiencesResultArray = [[NSMutableArray alloc] init];
                    
                    for (int i = 0; i < [experiences count]; i++) {
                        ExperienceModel *experienceModel = [[ExperienceModel alloc] init];
                        
                        NSDictionary *expericence = experiences[i];
                        
                        NSString *ageTypeKey = [expericence objectForKey:@"ageTypeKey"];
                        [experienceModel setAgeTypeKey:ageTypeKey];
                        
                        NSString *contentResourceTypeKey = [expericence objectForKey:@"contentResourceTypeKey"];
                        [experienceModel setContentResourceTypeKey:contentResourceTypeKey];
                        
                        NSString *contentResourceUrl = [expericence objectForKey:@"contentResourceUrl"];
                        [experienceModel setContentResourceUrl:contentResourceUrl];
                        
                        NSString *experienceBrief = [expericence objectForKey:@"experienceBrief"];
                        [experienceModel setExperienceBrief:experienceBrief];
                        
                        NSString *experienceDescription = [expericence objectForKey:@"experienceDescription"];
                        [experienceModel setExperienceDescription:experienceDescription];
                        
                        NSNumber *experienceID = [expericence objectForKey:@"experienceID"];
                        [experienceModel setExperienceID:experienceID];
                        
                        NSString *experienceName = [expericence objectForKey:@"experienceName"];
                        [experienceModel setExperienceName:experienceName];
                        
                        NSString *experienceTypeKey = [expericence objectForKey:@"experienceTypeKey"];
                        [experienceModel setExperienceTypeKey:experienceTypeKey];
                        
                        NSString *experienceUseTypeKey = [expericence objectForKey:@"experienceUseTypeKey"];
                        [experienceModel setExperienceUseTypeKey:experienceUseTypeKey];
                        
                        NSString *logoResourceTypeKey = [expericence objectForKey:@"logoResourceTypeKey"];
                        [experienceModel setLogoResourceTypeKey:logoResourceTypeKey];
                        
                        NSString *logoResourceUrl = [expericence objectForKey:@"logoResourceUrl"];
                        [experienceModel setLogoResourceUrl:logoResourceUrl];
                        
                        [experiencesResultArray addObject:experienceModel];
                        
                        [resultDic setObject:experiencesResultArray forKey:RESULT_KEY_DATA];
                    }
                    
                }
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
                
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
            
        }
        
        callback(resultDic);
        
    }];
}

@end
