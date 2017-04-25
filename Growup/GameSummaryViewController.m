//
//  GameSummaryViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/8.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "GameSummaryViewController.h"

@interface GameSummaryViewController ()

@end

@implementation GameSummaryViewController

- (IBAction)endGame:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)continueGame:(UIButton *)sender {
    UIViewController *controller = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:controller animated:YES];
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
