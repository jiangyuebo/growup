//
//  ExperienceViewModel.h
//  Growup
//
//  Created by Jerry on 2017/5/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExperienceViewModel : NSObject

#pragma mark 获取体验内容列表
- (void)getExperiencesListByAgeType:(NSString *) ageType andExperienceType:(NSString *) experienceType andPageIndex:(NSNumber *) pageIndex andPageSize:(NSNumber *) pageSize andCallback:(void (^)(NSDictionary *resultDic)) callback;

#pragma mark 获取体验内容明细
- (void)getExperienceDetailByID:(NSString *) experienceID andCallback:(void (^)(NSDictionary *resultDic)) callback;

#pragma mark 提交陪伴时间
- (void)sendCompanyTime:(NSNumber *) time;

@end
