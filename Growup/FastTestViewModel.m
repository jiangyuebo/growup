//
//  FastTestViewModel.m
//  Growup
//
//  Created by Jerry on 2017/5/2.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "FastTestViewModel.h"
#import "globalHeader.h"
#import "BMRequestHelper.h"
#import "TestSubjectModel.h"
#import "TestModel.h"

@implementation FastTestViewModel

#pragma mark 获取题目
- (void)getTestSubjectByChildId:(NSNumber *)childId andAgeType:(NSString *)ageType andEvaluationType:(NSString *)evaluationType andSex:(NSNumber *)sex andAbilityId:(NSString *)abilityId andCallback:(void (^)(NSDictionary *resultDic)) callback{
    
    //https://api.growtree.cn:443/cb/api/v1/user/evaluation/get/D24B99?ageType=D07B01&sex=1
    NSString *url_request = [NSString stringWithFormat:@"%@%@/%@?ageType=%@&sex=%@&abilityID=%@",URL_REQUEST,URL_REQUEST_TEST_SUBJECT_LIST,evaluationType,ageType,sex,abilityId];
    
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper getRequestAsynchronousToUrl:url_request andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        
        if (data) {
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            //套题对象
            TestModel *testModel = [[TestModel alloc] init];
            //获取套题信息
            NSDictionary *evaluation = [jsonDic objectForKey:@"evaluation"];
            
            NSNumber *evaluationID = [evaluation objectForKey:@"evaluationID"];
            [testModel setEvaluationID:evaluationID];
            
            NSString *ageTypeKey = [evaluation objectForKey:@"ageTypeKey"];
            [testModel setAgeTypeKey:ageTypeKey];
            
            NSString *evaluationTypeKey = [evaluation objectForKey:@"evaluationTypeKey"];
            [testModel setEvaluationTypeKey:evaluationTypeKey];
            
            NSString *evaluationName = [evaluation objectForKey:@"evaluationName"];
            [testModel setEvaluationName:evaluationName];
            
            NSString *evaluationDescription = [evaluation objectForKey:@"evaluationDescription"];
            [testModel setEvaluationDescription:evaluationDescription];
            
            NSString *logoResourceUrl = [evaluation objectForKey:@"logoResourceUrl"];
            [testModel setLogoResourceUrl:logoResourceUrl];
            
            NSString *logoResourceTypeKey = [evaluation objectForKey:@"logoResourceTypeKey"];
            [testModel setLogoResourceTypeKey:logoResourceTypeKey];
            
            NSString *contentResourceUrl = [evaluation objectForKey:@"contentResourceUrl"];
            [testModel setContentResourceUrl:contentResourceUrl];
            
            NSString *contentResourceTypeKey = [evaluation objectForKey:@"contentResourceTypeKey"];
            [testModel setContentResourceTypeKey:contentResourceTypeKey];
            
            //获取题目项
            NSArray *userEvaluationSubjects = [jsonDic objectForKey:@"userEvaluationSubjects"];
            
            NSMutableArray *subjects = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [userEvaluationSubjects count]; i++) {
                TestSubjectModel *testSubject = [[TestSubjectModel alloc] init];
                
                NSDictionary *userEvaluationSubject = [userEvaluationSubjects objectAtIndex:i];
                
                NSDictionary *evaluationSubject = [userEvaluationSubject objectForKey:@"evaluationSubject"];
                
                NSNumber *evaluationSubjectID = [evaluationSubject objectForKey:@"evaluationSubjectID"];
                [testSubject setEvaluationSubjectID:evaluationSubjectID];
                NSDictionary *subject = [evaluationSubject objectForKey:@"subject"];
                
                NSString *evaluationSubjectDescription = [evaluationSubject objectForKey:@"evaluationSubjectDescription"];
                [testSubject setEvaluationSubjectDescription:evaluationSubjectDescription];
                
                //--题目详细
                NSNumber *subjectID = [subject objectForKey:@"subjectID"];
                [testSubject setSubjectID:subjectID];
                
                NSString *ageTypeKey = [subject objectForKey:@"ageTypeKey"];
                [testSubject setAgeTypeKey:ageTypeKey];
                
                NSString *subjectTypeKey = [subject objectForKey:@"subjectTypeKey"];
                [testSubject setSubjectTypeKey:subjectTypeKey];
                
                NSString *subjectUseTypeKey = [subject objectForKey:@"subjectUseTypeKey"];
                [testSubject setSubjectUseTypeKey:subjectUseTypeKey];
                
                NSString *subjectOptionTypeKey = [subject objectForKey:@"subjectOptionTypeKey"];
                [testSubject setSubjectOptionTypeKey:subjectOptionTypeKey];
                
                NSString *subjectNum = [subject objectForKey:@"subjectNum"];
                [testSubject setSubjectNum:subjectNum];
                
                NSString *subjectName = [subject objectForKey:@"subjectName"];
                [testSubject setSubjectName:subjectName];
                
                NSString *subjectDescription = [subject objectForKey:@"subjectDescription"];
                [testSubject setSubjectDescription:subjectDescription];
                
                NSString *subjectBrief = [subject objectForKey:@"subjectBrief"];
                [testSubject setSubjectBrief:subjectBrief];
                
                NSString *logoResourceUrl = [subject objectForKey:@"logoResourceUrl"];
                [testSubject setLogoResourceUrl:logoResourceUrl];
                
                NSString *logoResourceTypeKey = [subject objectForKey:@"logoResourceTypeKey"];
                [testSubject setLogoResourceTypeKey:logoResourceTypeKey];
                
                NSString *contentResourceUrl = [subject objectForKey:@"contentResourceUrl"];
                [testSubject setContentResourceUrl:contentResourceUrl];
                
                NSString *contentResourceTypeKey = [subject objectForKey:@"contentResourceTypeKey"];
                [testSubject setContentResourceTypeKey:contentResourceTypeKey];
                
                NSString *correctOptionIDs = [subject objectForKey:@"correctOptionIDs"];
                [testSubject setCorrectOptionIDs:correctOptionIDs];
                
                NSString *correctAnswerValue = [subject objectForKey:@"correctAnswerValue"];
                [testSubject setCorrectAnswerValue:correctAnswerValue];
                
                [subjects addObject:testSubject];
            }
            
            [testModel setSubjectsArray:subjects];
            
            [resultDic setObject:testModel forKey:RESULT_KEY_DATA];
            
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
            
        }
        
        callback(resultDic);
    }];
}

#pragma mark 提交答案
- (void)sendTestAnwserToServerByEvaluationID:(NSNumber *) evaluationID andAnwserArray:(NSArray *) anwserArray andCallback:(void (^)(NSDictionary *resultDic)) callback{
    
    //api/v1/user/evaluation/submit/{evaluationID}
    NSString *url_request = [NSString stringWithFormat:@"%@%@/%@",URL_REQUEST,URL_REQUEST_SEND_ANWSER,evaluationID];
    
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper postRequestAsynchronousToUrl:url_request byParamsDic:anwserArray needAccessToken:YES andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        
        if (data) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSString *errorMessage = [jsonDic objectForKey:@"errorMsg"];
            if (errorMessage) {
                //错误
                [resultDic setObject:errorMessage forKey:RESULT_KEY_ERROR_MESSAGE];
            }else{
                //解析
                
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
        }
        callback(nil);
    }];
}

@end
