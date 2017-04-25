//
//  CZForgotPasswordViewController.m
//  Growup
//
//  Created by Jerry on 2017/4/25.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZForgotPasswordViewController.h"
#import "JerryViewTools.h"

@interface CZForgotPasswordViewController ()

@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;

@property (strong, nonatomic) IBOutlet UITextField *verifyCode;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) IBOutlet UIButton *getVerityCodeButton;

@end

@implementation CZForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView{
    //设置按钮风格
    [JerryViewTools setCZTextField:self.phoneNumber];
    [JerryViewTools setCZTextField:self.verifyCode];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
