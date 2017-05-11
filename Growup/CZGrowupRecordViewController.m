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
#import "JerryViewTools.h"

@interface CZGrowupRecordViewController ()

@property (strong,nonatomic) GrowupRecordViewModel *viewModel;

@property (strong,nonatomic) NSArray *recordsArray;

@end

@implementation CZGrowupRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self loadSelfRecord];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initView];
}

- (void)initData{
    self.viewModel = [[GrowupRecordViewModel alloc] init];

}

- (void)initView{
    
    
}

#pragma mark 查看自己橙长记
- (void)loadSelfRecord{
    
    [self.viewModel getGrowupRecordByRecordType:nil andPublicType:nil andIsInfo:NO andCallback:^(NSDictionary *resultDic) {
        
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
            
            //设置橙长记列表数组
            self.recordsArray = [result objectForKey:@"records"];
        }
        
    }];
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
