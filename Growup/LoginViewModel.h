//
//  LoginViewModel.h
//  Growup
//
//  Created by Jerry on 2017/4/21.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property (strong,nonatomic) NSString *userName;

@property (strong,nonatomic) NSString *password;

@property (strong,nonatomic) NSString *deviceId;

- (void)userLoginByUserName:(NSString *) userName andPassword:(NSString *) password callback:(void (^)(NSDictionary * resultDic)) callback;

#pragma mark 通过验证码登录
- (void)userLoginByPhoneNumber:(NSString *) phoneNumber andVerifyCode:(NSString *) verifyCode andCallback:(void (^)(NSDictionary *resultDic)) callback;

#pragma mark 通过验证码修改密码
- (void)resetPassword:(NSString *) password ByAccessTokenAndCallback:(void (^)(NSDictionary *resultDic)) callback;

@end
