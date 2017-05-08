//
//  CZRegisterViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/1.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZRegisterViewController.h"
#import "globalHeader.h"
#import "JerryViewTools.h"
#import "RegisterViewModel.h"
#import "CZTextField.h"
#import "JerryTools.h"
#import "JerryAnimation.h"

@interface CZRegisterViewController ()

@property (strong, nonatomic) IBOutlet UITextField *registerPhoneNumber;

@property (strong, nonatomic) IBOutlet UITextField *registerPassword;

@property (strong, nonatomic) IBOutlet UITextField *registerVerifyCode;

@property (strong, nonatomic) IBOutlet UIView *pageView;

//页面对象
@property (strong,nonatomic) RegisterViewModel *viewModel;

@end

@implementation CZRegisterViewController

- (IBAction)startRegister:(UIButton *)sender {
//    [JerryViewTools jumpFrom:self ToViewController:IdentifyBirthdaySettingViewController];
    
    NSString *phoneNumber = self.registerPhoneNumber.text;
    NSString *password = self.registerPassword.text;
    NSString *verifyCode = self.registerVerifyCode.text;
    
    //输入合法性验证
    if ([JerryTools stringIsNull:phoneNumber]) {
        //账号为空
        [JerryAnimation shakeToShow:self.registerPhoneNumber];
        //收起键盘
        [self clickPageView];
        //显示Toast
        [JerryViewTools showCZToastInViewController:self andText:@"请输入注册手机号"];
        return;

    }
    
    if ([JerryTools stringIsNull:password]) {
        //密码为空
        [JerryAnimation shakeToShow:self.registerPassword];
        //收起键盘
        [self clickPageView];
        //显示toast
        [JerryViewTools showCZToastInViewController:self andText:@"请输入注册密码"];
        return;
    }
    
    if ([JerryTools stringIsNull:verifyCode]) {
        //验证码为空
        [JerryAnimation shakeToShow:self.registerVerifyCode];
        //收起键盘
        [self clickPageView];
        //显示toast
        [JerryViewTools showCZToastInViewController:self andText:@"请输入验证码"];
        return;
    }
    
    [self.viewModel CZUserRegister:phoneNumber andPassword:password andVerifyCode:verifyCode andCallback:^(NSDictionary *resultDic) {
        
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            [self clickPageView];
            
            [JerryViewTools showCZToastInViewController:self andText:errorMessage];
        }else{
            //jump
            NSString *jumpPath = [resultDic objectForKey:RESULT_KEY_JUMP_PATH];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools jumpFrom:self ToViewController:jumpPath];
            });
        }
    }];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//获取验证码
- (IBAction)getVerifyCode:(UIButton *)sender {
    NSString *phoneNumberText = self.registerPhoneNumber.text;
    
    if ([JerryTools stringIsNull:phoneNumberText]) {
        //账号为空
        [JerryAnimation shakeToShow:self.registerPhoneNumber];
        //收起键盘
        [self clickPageView];
        //显示Toast
        [JerryViewTools showCZToastInViewController:self andText:@"请输入注册手机号"];
        return;
    }
    
    [self.viewModel getVerifyCode:phoneNumberText andVerifyCodeType:VERIFY_CODE_REGISTER andCallback:^(NSDictionary *resultDic) {
        
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self clickPageView];
                
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }
    }];
    
}

- (void)clickPageView{
    [self.registerPhoneNumber resignFirstResponder];
    [self.registerPassword resignFirstResponder];
    [self.registerVerifyCode resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
}

- (void)initData{
    //初始化页面对象
    self.viewModel = [[RegisterViewModel alloc] init];
    
    //绑定页面对象
    [self bindModel];
}

#pragma mark 绑定页面数据对象
- (void)bindModel{
    NSLog(@"数据对象绑定完成");
    //验证码
    [self.viewModel addObserver:self forKeyPath:OBSERVE_KEY_VERIFYCODE options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark 注销页面数据对象绑定
- (void)removeModelBind{
    [self.viewModel removeObserver:self forKeyPath:OBSERVE_KEY_VERIFYCODE];
}

#pragma mark 监听变化处理
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    
    if ([keyPath isEqualToString:OBSERVE_KEY_VERIFYCODE]) {
        //需要立刻刷新UI，使用主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.registerVerifyCode.text = [change objectForKey:@"new"];
        });
    }
}

- (void)initView{
    self.pageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPageView)];
    [self.pageView addGestureRecognizer:singleTap];
    
    //标题
    self.title = @"注册";
    
    //设置textfield高度
    [JerryViewTools setCZTextField:self.registerPhoneNumber];
    [JerryViewTools setCZTextField:self.registerPassword];
    [JerryViewTools setCZTextField:self.registerVerifyCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc{
    //删除数据对象监听
    [self removeModelBind];
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
