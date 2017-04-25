//
//  TabBarFrameViewController.m
//  Growup
//
//  Created by Jerry on 2017/2/5.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "TabBarFrameViewController.h"
#import "UIColor+NSString.h"
#import "globalHeader.h"
#import "JerryViewTools.h"

@interface TabBarFrameViewController ()<UITabBarControllerDelegate>

@end

@implementation TabBarFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView{
    [self setCustomTabBarItem];
    
    [self setCBNavigationBar];
}

- (void)setCBNavigationBar{
    //设置自定义 navigation bar
    [JerryViewTools showCustomNavigationBar:self];
    
    self.title = @"首页";
    
//    //自定义后退按钮
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
//    
//    //后退按钮和边界的占位控件
//    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixedItem.width = -10;
//    self.navigationItem.leftBarButtonItems = @[fixedItem,backItem];
}

//设置自定义 tab bar 图标
- (void)setCustomTabBarItem{
    UITabBar *tabBar = self.tabBar;
    
    //首页
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    item0.image = [[UIImage imageNamed:@"pc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.selectedImage = [[UIImage imageNamed:@"pc_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //体验
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    item1.image = [[UIImage imageNamed:@"ty"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [[UIImage imageNamed:@"ty_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //成长树
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    item2.image = [[UIImage imageNamed:@"czs"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"czs_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //发现
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    item3.image = [[UIImage imageNamed:@"fx"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"fx_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //我的
//    UITabBarItem *item4 = [tabBar.items objectAtIndex:4];
//    item4.image = [[UIImage imageNamed:@"wd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    item4.selectedImage = [[UIImage imageNamed:@"wd_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置选中后标题颜色
    for (int i = 0; i < [tabBar.items count]; i++) {
        //迭代所有tab bar item统一设置选中后字颜色
        NSMutableDictionary *textArrays = [NSMutableDictionary dictionary];
        textArrays[NSForegroundColorAttributeName] = [UIColor orangeColor];
        [[tabBar.items objectAtIndex:i] setTitleTextAttributes:textArrays forState:UIControlStateSelected];
    }
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
