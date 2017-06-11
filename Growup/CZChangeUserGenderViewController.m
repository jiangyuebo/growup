//
//  CZChangeUserGenderViewController.m
//  Growup
//
//  Created by Jerry on 2017/6/3.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZChangeUserGenderViewController.h"
#import "CZRadioSelectView.h"
#import "globalHeader.h"
#import "CZPersonCenterViewModel.h"

@interface CZChangeUserGenderViewController ()

@property (strong,nonatomic) CZRadioSelectView *radioView;

@end

@implementation CZChangeUserGenderViewController

@synthesize passDataDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断操作类型
    NSString *type = [passDataDic objectForKey:TYPE_KEY];
    if ([type isEqualToString:TYPE_VALUE_GENDER]) {
        //修改用户性别
        self.title = @"用户性别";
        
        self.radioView = [[CZRadioSelectView alloc] initWithFrame:CGRectMake(0,8, SCREENWIDTH,100)];
        NSMutableDictionary *selectItemsDic = [NSMutableDictionary dictionary];
        [selectItemsDic setObject:[NSNumber numberWithInt:1] forKey:@"先生"];
        [selectItemsDic setObject:[NSNumber numberWithInt:2] forKey:@"女士"];
        
        [self.radioView setSelectItemDic:selectItemsDic];
        NSMutableDictionary *defautItemDic = [NSMutableDictionary dictionary];
        NSNumber *sex = [passDataDic objectForKey:@"sex"];
        if ([sex intValue] == 0) {
            [defautItemDic setObject:@"0" forKey:@"通用"];
        }else
            if ([sex intValue] == 1) {
                [defautItemDic setObject:@"1" forKey:@"先生"];
            }else
                if ([sex intValue] == 2) {
                    [defautItemDic setObject:@"2" forKey:@"女士"];
                }
        
        [self.radioView setDefautSelect:defautItemDic];
    }
    
    if ([type isEqualToString:TYPE_VALUE_CHILD_GENDER]) {
        //孩子性别
        self.title = @"孩子性别";
        self.radioView = [[CZRadioSelectView alloc] initWithFrame:CGRectMake(0,8, SCREENWIDTH,100)];
        NSMutableDictionary *selectItemsDic = [NSMutableDictionary dictionary];
        [selectItemsDic setObject:[NSNumber numberWithInt:1] forKey:@"男孩"];
        [selectItemsDic setObject:[NSNumber numberWithInt:2] forKey:@"女孩"];
        
        [self.radioView setSelectItemDic:selectItemsDic];
        NSMutableDictionary *defautItemDic = [NSMutableDictionary dictionary];
        NSNumber *sex = [passDataDic objectForKey:@"sex"];
        if ([sex intValue] == 0) {
            [defautItemDic setObject:@"0" forKey:@"通用"];
        }else
            if ([sex intValue] == 1) {
                [defautItemDic setObject:@"1" forKey:@"男孩"];
            }else
                if ([sex intValue] == 2) {
                    [defautItemDic setObject:@"2" forKey:@"女孩"];
                }
        
        [self.radioView setDefautSelect:defautItemDic];
    }
    
    [self.view addSubview:self.radioView];
}

- (void)dealloc{
    NSString *type = [passDataDic objectForKey:TYPE_KEY];
    CZPersonCenterViewModel *modelView = [[CZPersonCenterViewModel alloc] init];
    
    if ([type isEqualToString:TYPE_VALUE_GENDER]) {
        //
        if (self.radioView.selectedValue) {
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
            [infoDic setObject:self.radioView.selectedValue forKey:@"sex"];
            
            [modelView changeUserInfo:infoDic andCallback:^(NSDictionary *resultDic) {
                
            }];
        }
    }
    
    if ([type isEqualToString:TYPE_VALUE_CHILD_GENDER]) {
        //
        if (self.radioView.selectedValue) {
            
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
            NSMutableDictionary *changeDic = [NSMutableDictionary dictionary];
            [changeDic setObject:self.radioView.selectedValue forKey:@"sex"];
            [infoDic setObject:changeDic forKey:@"child"];
            
            [modelView changeChildInfo:infoDic andCallback:^(NSDictionary *resultDic) {
                
            }];
        }
    }
    
    
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
