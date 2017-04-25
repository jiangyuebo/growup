//
//  CZMemberCenterViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/1.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZMemberCenterViewController.h"
#import "GlobalBusinessLayer.h"
#import "JerryViewTools.h"
#import "globalHeader.h"

#import "UIColor+NSString.h"

@interface CZMemberCenterViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *memberAvatar;

@end

@implementation CZMemberCenterViewController

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击头像
- (void)clickAvatar{
    //判断当前是否已登录
    if ([GlobalBusinessLayer checkLoginStatus]) {
        //已登录
    }else{
        //未登录,弹出登录界面
        [JerryViewTools jumpFrom:self ToViewController:IdentifyNameLoginViewController];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initView{
    
    //为头像添加点击事件
    self.memberAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAvatar)];
    [self.memberAvatar addGestureRecognizer:singleTap];

    //显示navigation bar
    [self displayNavigationBar];
}

//显示navigation bar
- (void)displayNavigationBar{

    //设置标题
    self.title = @"我的";
    
//    UIButton *backButton = [JerryViewTools setCustomNavigationBackButton:self];
//    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
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
