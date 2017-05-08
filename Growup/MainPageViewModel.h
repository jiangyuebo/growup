//
//  MainPageViewModel.h
//  Growup
//
//  Created by Jerry on 2017/3/2.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainPageViewModel : NSObject

//userId
@property (strong,nonatomic) NSString *userId;
//孩子年龄
@property (strong,nonatomic) NSNumber *age;
//孩子年龄显示
@property (strong,nonatomic) NSString *ageStr;
//是否需要测评
@property (nonatomic) BOOL needTest;

//任务数
@property (strong,nonatomic) NSNumber *taskCount;
//完成任务数
@property (strong,nonatomic) NSNumber *taskFinish;
//任务列表
@property (strong,nonatomic) NSArray *tasks;
//推荐任务列表/taskCover,taskId,taskName
@property (strong,nonatomic) NSArray *recommends;
//首页广告横幅图片
@property (strong,nonatomic) NSString *adurl;

#pragma mark 根据孩子信息获取气泡数据
- (void)queryOrangePopInfoById:(NSNumber *) childId andDynamicId:(NSNumber *) dynamicId andCallBack:(void(^)(NSDictionary * resultDic)) callback;

#pragma mark 获取橙娃能力动态
- (void)queryChildStatusInfoByChildId:(NSNumber *) childId andAgeType:(NSString *) ageType andCallback:(void (^)(NSDictionary * resultDic)) callback;

#pragma mark 获取行动列表
- (void)queryActionListByAgeType:(NSString *)ageType andActionDate:(NSDate *) date andIsRefresh:(BOOL) isRefresh andCallback:(void (^)(NSDictionary * resultDic)) callback;

#pragma mark 提交行动项
- (void)submitActionByUserActionID:(NSString *)userAction andOptionResultType:(NSString *)optionResultType andUserActionExperienceID:(NSString *)userActionExperienceID andUserActionTaskID:(NSString *)userActionTaskID andUserActionSubjectID:(NSString *)userActionSubjectID andCallback:(void (^)(NSDictionary * resultDic))callback;

#pragma mark 根据access-token获取用户及孩子信息
- (void)getUserInfoByAccesstoken:(NSString *) accesstoken andCallback:(void (^)(NSDictionary *resultDic)) callback;

@end
