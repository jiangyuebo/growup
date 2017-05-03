//
//  RegisterViewModel.h
//  Growup
//
//  Created by Jerry on 2017/3/23.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define OBSERVE_KEY_VERIFYCODE @"verifyCode"

@interface RegisterViewModel : NSObject

@property (strong,nonatomic) NSString *userName;

@property (strong,nonatomic) NSString *password;

@property (strong,nonatomic) NSString *verifyCode;

@property (strong,nonatomic) NSString *errorMessage;

#pragma mark 获取验证码
- (void)getVerifyCode:(NSString *) phoneNumber;

#pragma mark 用户注册
- (void)CZUserRegister:(NSString *) _phoneNumber andPassword:(NSString *) _password andVerifyCode:(NSString *) _verifyCode andCallback:(void (^)(NSDictionary * resultDic)) callback;

@end
