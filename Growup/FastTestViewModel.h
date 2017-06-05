//
//  FastTestViewModel.h
//  Growup
//
//  Created by Jerry on 2017/5/2.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FastTestViewModel : NSObject

#pragma mark 获取题目
- (void)getTestSubjectByChildId:(NSNumber *)childId andAgeType:(NSString *)ageType andEvaluationType:(NSString *)evaluationType andSex:(NSNumber *)sex andAbilityId:(NSString *)abilityId andCallback:(void (^)(NSDictionary *resultDic)) callback;

#pragma mark 提交答案
- (void)sendTestAnwserToServerByEvaluationID:(NSNumber *) evaluationID andAnwserArray:(NSArray *) anwserArray andIndexTpye:(NSString *)indexType andCallback:(void (^)(NSDictionary *resultDic)) callback;

@end
