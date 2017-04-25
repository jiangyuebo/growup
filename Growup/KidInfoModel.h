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
@property (nonatomic) NSUInteger age;
//是否需要测评
@property (nonatomic) BOOL needTest;

@end
