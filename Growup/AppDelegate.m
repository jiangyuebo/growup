//
//  AppDelegate.m
//  Growup
//
//  Created by Jerry on 2017/2/4.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "AppDelegate.h"
#import "ExperienceViewModel.h"

@interface AppDelegate ()

@property (nonatomic) NSTimeInterval startTime;

@end

@implementation AppDelegate

@synthesize accessExpiredIn,accessToken,globalPicCache;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //获取设备唯一标识
    self.deviceID = [self getCZDeviceId];
    //初始化当前用户数据全局变量
    self.currentUserInfo = [[UserInfoModel alloc] init];
    
    //初始化全局图片缓存
    globalPicCache = [NSMutableDictionary dictionary];
    
    //陪伴时间开始
    self.startTime = [[NSDate date] timeIntervalSince1970];
    
    // 启动图片延时
    [NSThread sleepForTimeInterval:3];
    
    return YES;
}

- (NSString *)getCZDeviceId{
    
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    return identifierForVendor;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //本次陪伴时间结束
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    int companyTime = endTime - self.startTime;
    NSLog(@"陪伴时间为 ： %d",companyTime);
    
    ExperienceViewModel *viewMode = [[ExperienceViewModel alloc] init];
    [viewMode sendCompanyTime:[NSNumber numberWithInt:companyTime]];
    
    self.startTime = 0;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
