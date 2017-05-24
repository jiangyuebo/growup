//
//  AppDelegate.h
//  Growup
//
//  Created by Jerry on 2017/2/4.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) NSString *deviceID;
@property (strong,nonatomic) NSNumber *accessExpiredIn;
@property (strong,nonatomic) NSString *accessToken;

//全局图片缓存
@property (strong,nonatomic) NSMutableDictionary *globalPicCache;

//用户数据
@property (strong,nonatomic) UserInfoModel *currentUserInfo;

@end

