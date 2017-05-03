//
//  KidInfoModel.h
//  Growup
//
//  Created by Jerry on 2017/3/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KidInfoModel : NSObject

//年龄显示字符串
@property (strong,nonatomic) NSString *ageStr;
//孩子年龄
@property (strong,nonatomic) NSNumber *age;
//
@property (strong,nonatomic) NSString *name;

//是否需要测评
@property (nonatomic) BOOL needTest;

@property (strong,nonatomic) NSString *ageTypeKey;

@property (strong,nonatomic) NSNumber *childID;

@property (strong,nonatomic) NSDate *birthDay;

@property (strong,nonatomic) NSDictionary *birthdayDic;

@property (strong,nonatomic) NSNumber *sex;

@property (strong,nonatomic) NSString *avatorUrl;

//使用者与孩子的关系
@property (strong,nonatomic) NSString *educationRoleTypeKey;
//教育类型
@property (strong,nonatomic) NSString *educationTypeKey;

@end
