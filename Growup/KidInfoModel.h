//
//  KidInfoModel.h
//  Growup
//
//  Created by Jerry on 2017/3/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KidInfoModel : NSObject

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSString *userChildID;

//是否需要测评
@property (nonatomic) BOOL needTest;

@property (strong,nonatomic) NSString *ageTypeKey;

@property (strong,nonatomic) NSNumber *childID;

@property (strong,nonatomic) NSDate *birthDay;

@property (strong,nonatomic) NSDictionary *birthdayDic;

@property (strong,nonatomic) NSNumber *sex;

@property (strong,nonatomic) NSString *avatorUrl;

@property (strong,nonatomic) NSNumber *accompanyRate;

@property (strong,nonatomic) NSNumber *accompanyTime;

//使用者与孩子的关系
@property (strong,nonatomic) NSString *educationRoleTypeKey;
//教育类型
@property (strong,nonatomic) NSString *educationTypeKey;

@end
