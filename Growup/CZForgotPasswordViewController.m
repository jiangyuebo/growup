//
//  CZForgotPasswordViewController.m
//  Growup
//
//  Created by Jerry on 2017/4/25.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZForgotPasswordViewController.h"
#import "JerryViewTools.h"
#import "JerryTools.h"
#import "JerryAnimation.h"
#import "RegisterViewModel.h"
#import "globalHeader.h"
#import "LoginViewModel.h"

@interface CZForgotPasswordViewController ()

@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;

@property (strong, nonatomic) IBOutlet UITextField *verifyCode;

@property (strong, nonatomic) IBOutlet UIView *pageView;

@property (strong,nonatomic) RegisterViewModel *viewMode;

@end

@implementation CZForgotPasswordViewController

#pragma mark 获取验证码
- (IBAction)getVerifyCode:(UIButton *)sender {
    
    NSString *phoneNumberStr = self.phoneNumber.text;
    if ([JerryTools stringIsNull:phoneNumberStr]) {
        //账号为空
        [JerryAnimation shakeToShow:self.phoneNumber];
        //收起键盘
        [self clickPageView];
        //显示Toast
        [JerryViewTools showCZToastInViewController:self andText:@"请输入注册手机号"];
        return;
    }
    
    [self.viewMode getVerifyCode:phoneNumberStr andVerifyCodeType:VERIFY_CODE_VERIFY_CODE_LOGIN andCallback:^(NSDictionary *result) {
        
        NSString *errorMessage = [result objectForKey:RESULT_KEY_ERROR_MESSAGE];
        
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self clickPageView];
                
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            //
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSString *verifyCode = [result objectForKey:RESULT_KEY_DATA];
                self.verifyCode.text = verifyCode;
            });
        }
    }];
}

- (IBAction)loginBtn:(UIButton *)sender {
    NSString *phoneNumberStr = self.phoneNumber.text;
    NSString *verifyCodeStr = self.verifyCode.text;
    
    if ([JerryTools stringIsNull:phoneNumberStr]) {
        //账号为空
        [JerryAnimation shakeToShow:self.phoneNumber];
        //收起键盘
        [self clickPageView];
        //显示Toast
        [JerryViewTools showCZToastInViewController:self andText:@"请输入手机号"];
        return;
    }
    
    if ([JerryTools stringIsNull:verifyCodeStr]) {
        //验证码为空
        [JerryAnimation shakeToShow:self.phoneNumber];
        //收起键盘
        [self clickPageView];
        //显示Toast
        [JerryViewTools showCZToastInViewController:self andText:@"请输入验证码"];
        return;
    }
    
    LoginViewModel *loginViewModel = [[LoginViewModel alloc] init];
    [loginViewModel userLoginByPhoneNumber:phoneNumberStr andVerifyCode:verifyCodeStr andCallback:^(NSDictionary *resultDic) {
        
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSString *path = [resultDic objectForKey:RESULT_KEY_JUMP_PATH];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools jumpFrom:self ToViewController:path];
            });
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView{
    //设置按钮风格
    [JerryViewTools setCZTextField:self.phoneNumber];
    [JerryViewTools setCZTextField:self.verifyCode];
    
    self.viewMode = [[RegisterViewModel alloc] init];
    
    [self setPageViewClickable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickPageView{
    [self.phoneNumber resignFirstResponder];
    [self.verifyCode resignFirstResponder];
}

- (void)setPageViewClickable{
    self.pageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPageView)];
    [self.pageView addGestureRecognizer:singleTap];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
