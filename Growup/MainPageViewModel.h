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
//评分
@property (strong,nonatomic) NSDictionary *score;


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

//更新数据
- (void)updateData;

#pragma mark 根据孩子信息获取数据
- (void)getChildInfoById:(NSNumber *) childId andDynamicId:(NSString *) dynamicId;

@end
