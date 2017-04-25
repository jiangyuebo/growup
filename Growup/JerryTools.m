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

@end
