//
//  CZGrowupRecordViewController.m
//  Growup
//
//  Created by Jerry on 2017/5/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZGrowupRecordViewController.h"
#import "GrowupRecordViewModel.h"
#import "globalHeader.h"

@interface CZGrowupRecordViewController ()

@property (strong,nonatomic) GrowupRecordViewModel *viewModel;

@end

@implementation CZGrowupRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initView];
}

- (void)initData{
    self.viewModel = [[GrowupRecordViewModel alloc] init];
    //获取橙长记列表
    [self getSelfRecord];
}

- (void)initView{

    [self.viewModel getGrowupRecordByRecordType:nil andPublicType:nil andIsInfo:NO andCallback:^(NSDictionary *resultDic) {
        
    }];
}

#pragma mark 查看自己橙长记
- (void)getSelfRecord{
    
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
