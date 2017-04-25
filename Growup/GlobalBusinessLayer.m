//
//  GlobalBusinessLayer.m
//  Growup
//
//  Created by Jerry on 2017/3/1.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "GlobalBusinessLayer.h"
#import "FileCommonTool.h"
#import "globalHeader.h"

@implementation GlobalBusinessLayer

#pragma mark 判断当前登录态
+ (BOOL)checkLoginStatus{
    
    //读取本地存储的登录态数据
    NSString *token = [FileCommonTool readInfo:TOKEN];
    if (token) {
        return YES;
    }else{
        return NO;
    }
}

@end
