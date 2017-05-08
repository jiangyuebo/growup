//
//  CZChangePasswordViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/20.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZChangePasswordViewController.h"
#import "JerryViewTools.h"
#import "JerryTools.h"
#import "JerryAnimation.h"
#import "LoginViewModel.h"
#import "globalHeader.h"

@interface CZChangePasswordViewController ()

@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic) IBOutlet UITextField *passwordRepeat;

@property (strong, nonatomic) IBOutlet UIView *viewPage;

@end

@implementation CZChangePasswordViewController

- (IBAction)submitClicked:(UIButton *)sender {
    
    NSString *passwordStr = self.password.text;
    NSString *passwordRepeatStr = self.passwordRepeat.text;
    
    //输入合法性验证
    if ([JerryTools stringIsNull:passwordStr]) {
        //为空
        [JerryAnimation shakeToShow:self.password];
        //收起键盘
        [self clickPageView];
        //显示Toast
        [JerryViewTools showCZToastInViewController:self andText:@"请设置密码"];
        return;
    }
    
    //输入合法性验证
    if ([JerryTools stringIsNull:passwordRepeatStr]) {
        //为空
        [JerryAnimation shakeToShow:self.passwordRepeat];
        //收起键盘
        [self clickPageView];
        //显示Toast
        [JerryViewTools showCZToastInViewController:self andText:@"请确认密码"];
        return;
    }
    
    if ([passwordStr isEqualToString:passwordRepeatStr]) {
        LoginViewModel *loginViewMode = [[LoginViewModel alloc] init];
        [loginViewMode resetPassword:passwordStr ByAccessTokenAndCallback:^(NSDictionary *resultDic) {
            
            NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
            if (errorMessage) {
                //error
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [JerryViewTools showCZToastInViewController:self andText:errorMessage];
                });
            }else{
                NSString *path = [resultDic objectForKey:RESULT_KEY_JUMP_PATH];
                if ([path isEqualToString:IdentifyNameMainViewController]) {
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [[self navigationController] popToRootViewControllerAnimated:YES];
                    });
                }
            }
        }];
        
    }else{
        [JerryAnimation shakeToShow:self.passwordRepeat];
        //收起键盘
        [self clickPageView];
        //显示Toast
        [JerryViewTools showCZToastInViewController:self andText:@"两次密码设置不一致"];
        return;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView{
    self.viewPage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPageView)];
    [self.viewPage addGestureRecognizer:singleTap];
    
    //
    [JerryViewTools setCZTextField:self.password];
    [JerryViewTools setCZTextField:self.passwordRepeat];
}

- (void)clickPageView{
    [self.password resignFirstResponder];
    [self.passwordRepeat resignFirstResponder];
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
