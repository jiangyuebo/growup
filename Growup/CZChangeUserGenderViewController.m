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
    
    [self.view addSubview:self.radioView];
}

- (void)dealloc{
    //
    if (self.radioView.selectedValue) {
        CZPersonCenterViewModel *modelView = [[CZPersonCenterViewModel alloc] init];
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        [infoDic setObject:self.radioView.selectedValue forKey:@"sex"];
        
        [modelView changeUserInfo:infoDic andCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"还没有被 delloc");
            
        }];
        
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
