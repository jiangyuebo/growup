//
//  CZLoginViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/1.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZLoginViewController.h"
#import "globalHeader.h"
#import "JerryViewTools.h"
#import "LoginViewModel.h"
#import "CZTextField.h"
#import "JerryTools.h"
#import "JerryAnimation.h"

@interface CZLoginViewController ()

@property (strong, nonatomic) IBOutlet CZTextField *loginPhoneNumber;

@property (strong, nonatomic) IBOutlet CZTextField *loginPassword;

@property (strong, nonatomic) IBOutlet UIView *pageView;

@end

@implementation CZLoginViewController

//登录
- (IBAction)startLoign:(UIButton *)sender {
    
    //用户名
    NSString *userName = self.loginPhoneNumber.text;
    //密码
    NSString *password = self.loginPassword.text;
    
    //用户输入合法性验证
    if ([JerryTools stringIsNull:userName]) {
        //用户名是空
        [JerryAnimation shakeToShow:self.loginPhoneNumber];
        //收起键盘
        [self clickPageView];
        //显示Toast
        [JerryViewTools showCZToastInViewController:self andText:@"请输入用户名"];
        return;
    }
    
    if ([JerryTools stringIsNull:password]) {
        //密码是空
        [JerryAnimation shakeToShow:self.loginPassword];
        //收起键盘
        [self clickPageView];
        //显示Toast
        [JerryViewTools showCZToastInViewController:self andText:@"请输入登录密码"];
        return;
    }
    
    if (userName && password) {
        LoginViewModel *viewModel = [[LoginViewModel alloc] init];
        
        [viewModel userLoginByUserName:userName andPassword:password];
    }
}

//注册
- (IBAction)startRegister:(UIButton *)sender {
    [JerryViewTools jumpFrom:self ToViewController:IdentifyNameRegisterViewController];
}

//后退
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView{
    self.pageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPageView)];
    [self.pageView addGestureRecognizer:singleTap];
    
    [self displayNavigationBar];
    
    //设置输入框
    [JerryViewTools setCZTextField:self.loginPhoneNumber];
    [JerryViewTools setCZTextField:self.loginPassword];
    
}

//显示navigation bar
- (void)displayNavigationBar{
    
    //设置标题
    self.title = @"登录";
    
//    UIButton *backButton = [JerryViewTools setCustomNavigationBackButton:self];
//    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickPageView{
    NSLog(@"clickPageView");
    [self.loginPhoneNumber resignFirstResponder];
    [self.loginPassword resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
