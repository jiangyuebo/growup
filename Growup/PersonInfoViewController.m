//
//  PersonInfoViewController.m
//  Growup
//
//  Created by Jerry on 2017/5/13.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "JerryTools.h"
#import "JerryViewTools.h"
#import "CZLoginViewController.h"
#import "globalHeader.h"
#import "UserInfoModel.h"

@interface PersonInfoViewController ()

@property (strong, nonatomic) IBOutlet UILabel *userInfo;

@end

@implementation PersonInfoViewController

- (IBAction)loginOut:(UIButton *)sender {
    
    //退出登录
    //删除本地用户信息
    [JerryTools eraseUserLoginStatus];
    //跳转至登录页面
    CZLoginViewController *loginViewController = [JerryViewTools getViewControllerById:IdentifyNameLoginViewController];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserInfoModel *userInfoModel = [JerryTools getUserInfoModel];
    NSString *phoneNumber = [userInfoModel phoneNumber];
    NSString *showLabel = [NSString stringWithFormat:@"当前用户账号：%@",phoneNumber];
    
    self.userInfo.text = showLabel;
    
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
