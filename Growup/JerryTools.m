//
//  JerryTools.m
//  Growup
//
//  Created by Jerry on 2017/4/21.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "JerryTools.h"
#import "AppDelegate.h"

@implementation JerryTools

+ (NSString *) getCZDeviceId{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate.deviceID;
}

+ (UserInfoModel *) getUserInfoModel{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate.currentUserInfo;
}

+ (void) setAccessToken:(NSString *) accessToken{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.accessToken = accessToken;
}

+ (NSString *) getAccessToken{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate.accessToken;
}

+ (void) setAccessExpireTime:(NSNumber *) expireTime{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.accessExpiredIn = expireTime;
}

#pragma mark - 判断字符串是否为空，包括(nil，nsnull，@"")
+ (BOOL)stringIsNull:(NSString *)str{
    if(str == nil || [str isEqual:[NSNull null]]){
        return YES;
    }else{
        if(str.length < 1){
            return YES;
        }
        
        return NO;
    }
}

#pragma mark - userDefault文件操作
#pragma mark 保存
+(void)saveInfo:(id)data name:(NSString *)name{
    
    if(data == nil || name == nil){
        NSLog(@"保存的数据或键值为空，请注意");
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:name];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 读取
+(id)readInfo:(NSString *)name{
    if(name == nil){
        return nil;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}

#pragma mark 删除
+(void)removeInfo:(NSString *)name{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
