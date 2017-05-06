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
#import "PopInfoModel.h"
#import "AbilityModel.h"
#import "MainPageActionInfoModel.h"
#import "ActionSubject.h"
#import "ActionExperience.h"
#import "ActionTask.h"

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
                NSArray *array = (NSArray *)jsonObject;
                
                NSMutableArray *popInfoArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < [array count]; i++) {
                    PopInfoModel *popInfo = [[PopInfoModel alloc] init];
                    
                    NSDictionary *infoDic = [array objectAtIndex:i];
                    
                    NSString *ageTypeKey = [infoDic objectForKey:@"ageTypeKey"];
                    [popInfo setAgeTypeKey:ageTypeKey];
                    
                    NSNumber *childDynamicID = [infoDic objectForKey:@"childDynamicID"];
                    [popInfo setChildDynamicID:childDynamicID];
                    
                    NSString *childDynamicTypeKey = [infoDic objectForKey:@"childDynamicTypeKey"];
                    [popInfo setChildDynamicTypeKey:childDynamicTypeKey];
                    
                    NSString *contentResourceTypeKey = [infoDic objectForKey:@"contentResourceTypeKey"];
                    [popInfo setContentResourceTypeKey:contentResourceTypeKey];
                    
                    NSString *contentResourceUrl = [infoDic objectForKey:@"contentResourceUrl"];
                    [popInfo setContentResourceUrl:contentResourceUrl];
                    
                    NSNumber *correctAnswerValue = [infoDic objectForKey:@"correctAnswerValue"];
                    [popInfo setCorrectAnswerValue:correctAnswerValue];
                    
                    NSString *infoDescription = [infoDic objectForKey:@"dynamicDescription"];
                    [popInfo setInfoDescription:infoDescription];
                    
                    NSString *infoName = [infoDic objectForKey:@"dynamicName"];
                    [popInfo setInfoName:infoName];
                    
                    NSString *logoResourceTypeKey = [infoDic objectForKey:@"logoResourceTypeKey"];
                    [popInfo setLogoResourceTypeKey:logoResourceTypeKey];
                    
                    NSString *logoResourceUrl = [infoDic objectForKey:@"logoResourceUrl"];
                    [popInfo setLogoResourceUrl:logoResourceUrl];
                    
                    NSNumber *score = [infoDic objectForKey:@"score"];
                    [popInfo setScore:score];
                    
                    NSNumber *weight = [infoDic objectForKey:@"weight"];
                    [popInfo setWeight:weight];
                    
                    [popInfoArray addObject:popInfo];
                }
                
                [resultDic setObject:popInfoArray forKey:RESULT_KEY_DATA];
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
        
        if (data) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            AbilityModel *abilityModel =  [[AbilityModel alloc] init];
            
            NSLog(@"jsonDic = %@",jsonDic);
            NSString *abilityStatusTypeKey = [jsonDic objectForKey:@"abilityStatusTypeKey"];
            [abilityModel setAbilityStatusTypeKey:abilityStatusTypeKey];
            
            NSNumber *indexArtScore = [jsonDic objectForKey:@"indexArtScore"];
            [abilityModel setIndexArtScore:indexArtScore];
            NSString *indexArtStatusTypeKey = [jsonDic objectForKey:@"indexArtStatusTypeKey"];
            [abilityModel setIndexArtStatusTypeKey:indexArtStatusTypeKey];
            
            NSNumber *indexHealthScore = [jsonDic objectForKey:@"indexHealthScore"];
            [abilityModel setIndexHealthScore:indexHealthScore];
            NSString *indexHealthStatusTypeKey = [jsonDic objectForKey:@"indexHealthStatusTypeKey"];
            [abilityModel setIndexHealthStatusTypeKey:indexHealthStatusTypeKey];
            
            NSNumber *indexLanguageScore = [jsonDic objectForKey:@"indexLanguageScore"];
            [abilityModel setIndexLanguageScore:indexLanguageScore];
            NSString *indexLanguageStatusTypeKey = [jsonDic objectForKey:@"indexLanguageStatusTypeKey"];
            [abilityModel setIndexLanguageStatusTypeKey:indexLanguageStatusTypeKey];
            
            NSNumber *indexScienceScore = [jsonDic objectForKey:@"indexScienceScore"];
            [abilityModel setIndexScienceScore:indexScienceScore];
            NSString *indexScienceStatusTypeKey = [jsonDic objectForKey:@"indexScienceStatusTypeKey"];
            [abilityModel setIndexScienceStatusTypeKey:indexScienceStatusTypeKey];
            
            NSNumber *indexSociologyScore = [jsonDic objectForKey:@"indexSociologyScore"];
            [abilityModel setIndexScienceScore:indexSociologyScore];
            NSString *indexSociologyStatusTypeKey = [jsonDic objectForKey:@"indexSociologyStatusTypeKey"];
            [abilityModel setIndexSociologyStatusTypeKey:indexSociologyStatusTypeKey];
            
            BOOL isAbilityExpired = [jsonDic objectForKey:@"isAbilityExpired"];
            [abilityModel setIsAbilityExpired:isAbilityExpired];
            
            NSNumber *userAbilityID = [jsonDic objectForKey:@"userAbilityID"];
            [abilityModel setUserAbilityID:userAbilityID];
            
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            [resultDic setObject:abilityModel forKey:RESULT_KEY_DATA];
            
            callback(resultDic);
            
        }else{
            NSLog(@"返回值中 data 是空");
            
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
            
            callback(resultDic);
        }
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
                //解析数据
                MainPageActionInfoModel *mainPageActionInfoModel = [[MainPageActionInfoModel alloc] init];
                
                //总体参数
                NSNumber *actionFinishNumber = [jsonDic objectForKey:@"actionFinishNumber"];
                [mainPageActionInfoModel setActionFinishNumber:actionFinishNumber];
                
                NSNumber *actionNumber = [jsonDic objectForKey:@"actionNumber"];
                [mainPageActionInfoModel setActionNumber:actionNumber];
                
                NSDate *actionTS = [jsonDic objectForKey:@"actionTS"];
                [mainPageActionInfoModel setActionTS:actionTS];
                
                NSNumber *childID = [jsonDic objectForKey:@"childID"];
                [mainPageActionInfoModel setChildID:childID];
                
                BOOL isFinish = [jsonDic objectForKey:@"isFinish"];
                [mainPageActionInfoModel setIsFinish:isFinish];
                
                NSNumber *userActionID = [jsonDic objectForKey:@"userActionID"];
                [mainPageActionInfoModel setUserActionID:userActionID];
                
                //userActionSubjects
                NSArray *userActionSubjects = [jsonDic objectForKey:@"userActionSubjects"];
                NSMutableArray *userActionSubjectReturnArray = [[NSMutableArray alloc] init];
                
                
                for (int i = 0; i < [userActionSubjects count]; i++) {
                    ActionSubject *actionSubject = [[ActionSubject alloc] init];
                    
                    NSDictionary *userActionSubject = userActionSubjects[i];
                    BOOL isAction = [userActionSubject objectForKey:@"isAction"];
                    [actionSubject setIsAction:isAction];
                    
                    NSString *actionStatusTypeKey = [userActionSubject objectForKey:@"actionStatusTypeKey"];
                    [actionSubject setActionStatusTypeKey:actionStatusTypeKey];
                    
                    NSDate *actionTS = [userActionSubject objectForKey:@"actionTS"];
                    [actionSubject setActionTS:actionTS];
                    
                    NSDictionary *subject = [userActionSubject objectForKey:@"subject"];
                    NSString *contentResourceTypeKey = [subject objectForKey:@"contentResourceTypeKey"];
                    [actionSubject setContentResourceTypeKey:contentResourceTypeKey];
                    
                    NSString *contentResourceUrl = [subject objectForKey:@"contentResourceUrl"];
                    [actionSubject setContentResourceUrl:contentResourceUrl];
                    
                    NSString *logoResourceTypeKey = [subject objectForKey:@"logoResourceTypeKey"];
                    [actionSubject setLogoResourceTypeKey:logoResourceTypeKey];
                    
                    NSString *logoResourceUrl = [subject objectForKey:@"logoResourceUrl"];
                    [actionSubject setLogoResourceUrl:logoResourceUrl];
                    
                    NSString *subjectDescription = [subject objectForKey:@"subjectDescription"];
                    [actionSubject setSubjectDescription:subjectDescription];
                    
                    NSNumber *subjectID = [subject objectForKey:@"subjectID"];
                    [actionSubject setSubjectID:subjectID];
                    
                    NSString *subjectName = [subject objectForKey:@"subjectName"];
                    [actionSubject setSubjectName:subjectName];
                    
                    NSString *subjectNum = [subject objectForKey:@"subjectNum"];
                    [actionSubject setSubjectNum:subjectNum];
                    
                    NSString *subjectOptionTypeKey = [subject objectForKey:@"subjectOptionTypeKey"];
                    [actionSubject setSubjectOptionTypeKey:subjectOptionTypeKey];
                    
                    NSString *subjectTypeKey = [subject objectForKey:@"subjectTypeKey"];
                    [actionSubject setSubjectTypeKey:subjectTypeKey];
                    
                    NSString *subjectUseTypeKey = [subject objectForKey:@"subjectUseTypeKey"];
                    [actionSubject setSubjectUseTypeKey:subjectUseTypeKey];
                    
                    [userActionSubjectReturnArray addObject:actionSubject];
                }
                [mainPageActionInfoModel setUserActionSubjects:userActionSubjectReturnArray];
                
                //userActionExperiences
                NSArray *userActionExperiences = [jsonDic objectForKey:@"userActionExperiences"];
                NSMutableArray *userActionExperiencesReturnArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < [userActionExperiences count]; i++) {
                    ActionExperience *actionExperience = [[ActionExperience alloc] init];
                    
                    NSDictionary *userActionExperience = userActionExperiences[i];
                    
                    NSString *actionStatusTypeKey = [userActionExperience objectForKey:@"actionStatusTypeKey"];
                    [actionExperience setActionStatusTypeKey:actionStatusTypeKey];
                    
                    NSDate *actionTS = [userActionExperience objectForKey:@"actionTS"];
                    [actionExperience setActionTS:actionTS];
                    
                    BOOL isAction = [userActionExperience objectForKey:@"isAction"];
                    [actionExperience setIsAction:isAction];
                    
                    NSDictionary *experience = [userActionExperience objectForKey:@"experience"];
                    NSString *contentResourceUrl = [experience objectForKey:@"contentResourceUrl"];
                    [actionExperience setContentResourceUrl:contentResourceUrl];
                    
                    NSNumber *experienceID = [experience objectForKey:@"experienceID"];
                    [actionExperience setExperienceID:experienceID];
                    
                    NSString *experienceName = [experience objectForKey:@"experienceName"];
                    [actionExperience setExperienceName:experienceName];
                    
                    NSString *experienceTypeKey = [experience objectForKey:@"experienceTypeKey"];
                    [actionExperience setExperienceTypeKey:experienceTypeKey];
                    
                    NSString *logoResourceTypeKey = [experience objectForKey:@"logoResourceTypeKey"];
                    [actionExperience setLogoResourceTypeKey:logoResourceTypeKey];
                    
                    NSString *logoResourceUrl = [experience objectForKey:@"logoResourceUrl"];
                    [actionExperience setLogoResourceUrl:logoResourceUrl];
                    
                    [userActionExperiencesReturnArray addObject:actionExperience];
                }
                [mainPageActionInfoModel setUserActionExperiences:userActionExperiencesReturnArray];
                
                //userActionTasks
                NSArray *userActionTasks = [jsonDic objectForKey:@"userActionTasks"];
                NSMutableArray *userActionTasksReturnArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < [userActionTasks count]; i++) {
                    ActionTask *actionTask = [[ActionTask alloc] init];
                    
                    NSDictionary *userActionTask = userActionTasks[i];
                    
                    NSString *actionStatusTypeKey = [userActionTask objectForKey:@"actionStatusTypeKey"];
                    [actionTask setActionStatusTypeKey:actionStatusTypeKey];
                    
                    NSDate *actionTS = [userActionTask objectForKey:@"actionTS"];
                    [actionTask setActionTS:actionTS];
                    
                    BOOL isAction = [userActionTask objectForKey:@"isAction"];
                    [actionTask setIsAction:isAction];
                    
                    //task
                    NSDictionary *task = [userActionTask objectForKey:@"task"];
                    
                    NSString *contentResourceTypeKey = [task objectForKey:@"contentResourceTypeKey"];
                    [actionTask setContentResourceTypeKey:contentResourceTypeKey];
                    
                    NSString *contentResourceUrl = [task objectForKey:@"contentResourceUrl"];
                    [actionTask setContentResourceUrl:contentResourceUrl];
                    
                    NSString *logoResourceTypeKey = [task objectForKey:@"logoResourceTypeKey"];
                    [actionTask setLogoResourceTypeKey:logoResourceTypeKey];
                    
                    NSString *logoResourceUrl = [task objectForKey:@"logoResourceUrl"];
                    [actionTask setLogoResourceUrl:logoResourceUrl];
                    
                    NSString *taskActionDescription = [task objectForKey:@"taskActionDescription"];
                    [actionTask setTaskActionDescription:taskActionDescription];
                    
                    NSString *taskActionTypeKey = [task objectForKey:@"taskActionTypeKey"];
                    [actionTask setTaskActionTypeKey:taskActionTypeKey];
                    
                    NSString *taskDescription = [task objectForKey:@"taskDescription"];
                    [actionTask setTaskDescription:taskDescription];
                    
                    NSNumber *taskID = [task objectForKey:@"taskID"];
                    [actionTask setTaskID:taskID];
                    
                    NSString *taskName = [task objectForKey:@"taskName"];
                    [actionTask setTaskName:taskName];
                    
                    NSString *taskTypeKey = [task objectForKey:@"taskTypeKey"];
                    [actionTask setTaskTypeKey:taskTypeKey];
                    
                    NSString *taskUseTypeKey = [task objectForKey:@"taskUseTypeKey"];
                    [actionTask setTaskUseTypeKey:taskUseTypeKey];
                    
                    [userActionTasksReturnArray addObject:actionTask];
                }
                [mainPageActionInfoModel setUserActionTasks:userActionTasksReturnArray];
                
                [resultDic setObject:mainPageActionInfoModel forKey:RESULT_KEY_DATA];
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
        }
        
        callback(resultDic);
        
    }];
}

#pragma mark 提交行动项
- (void)submitActionByUserActionID:(NSString *)userActionID andOptionResultType:(NSString *)optionResultType andUserActionExperienceID:(NSString *)userActionExperienceID andUserActionTaskID:(NSString *)userActionTaskID andUserActionSubjectID:(NSString *)userActionSubjectID andCallback:(void (^)(NSDictionary * resultDic))callback{
    
    //api/v1/user/action/submit/{userActionID}/{optionResultType}?userActionExperienceID={userActionExperienceID}&userActionTaskID={userActionTaskID}&userActionSubjectID={userActionSubjectID}
    NSString *url_request = [NSString stringWithFormat:@"%@%@/%@/%@?userActionExperienceID=%@&userActionTaskID=%@&userActionSubjectID=%@",URL_REQUEST,URL_REQUEST_SUBMIT_ACTION,userActionID,optionResultType,userActionExperienceID,userActionTaskID,userActionSubjectID];
    
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
