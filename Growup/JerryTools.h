//
//  JerryTools.h
//  Growup
//
//  Created by Jerry on 2017/4/21.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface JerryTools : NSObject

#pragma mark 获取设备device ID
+ (NSString *) getCZDeviceId;

#pragma mark 获取全局用户数据
+ (UserInfoModel *) getUserInfoModel;

#pragma mark 设置全局access token
+ (void) setAccessToken:(NSString *) accessToken;

#pragma mark 获取全局access token
+ (NSString *) getAccessToken;

#pragma mark 设置 access token 过期时间
+ (void) setAccessExpireTime:(NSNumber *) expireTime;

#pragma mark - 判断字符串是否为空，包括(nil，nsnull，@"")
+ (BOOL)stringIsNull:(NSString *)str;

@end
