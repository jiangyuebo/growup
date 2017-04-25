//
//  CZinterestingSettingViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/20.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZinterestingSettingViewController.h"
#import "globalHeader.h"
#import "JerryViewTools.h"
#import "InterestingSettingViewModel.h"

@interface CZinterestingSettingViewController ()

@end

@implementation CZinterestingSettingViewController

@synthesize passDataDic;

- (IBAction)save:(UIButton *)sender {
    //回弹到首页
//    UIViewController *controller = self.navigationController.viewControllers[0];
//    [self.navigationController popToViewController:controller animated:YES];
    
    InterestingSettingViewModel *viewModel = [[InterestingSettingViewModel alloc] init];
    [viewModel setChildSetting:self.passDataDic andJumpTo:^(NSString *address) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
