//
//  CZTrackUploadViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/22.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZTrackUploadViewController.h"
#import "globalHeader.h"
#import "TrackUploadModel.h"
#import "JerryTools.h"
#import "JerryViewTools.h"

@interface CZTrackUploadViewController ()

@property (strong, nonatomic) IBOutlet UITextView *uploadText;

@property (strong, nonatomic) IBOutlet UILabel *locationText;

@property (strong, nonatomic) IBOutlet UILabel *authorityText;

@property (strong,nonatomic) TrackUploadModel *viewModel;

@end

@implementation CZTrackUploadViewController

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initView];
}

- (void)initView{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.uploadText.contentOffset = CGPointMake(0, -64);
    
    //添加发送按钮
    UIBarButtonItem *sendRecord = [[UIBarButtonItem alloc]
                                initWithTitle:@"发送"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(sendRecord)];
    
    self.navigationItem.rightBarButtonItem = sendRecord;
}

- (void)sendRecord{
    //检查内容是否为空
    NSString *contentStr = self.uploadText.text;
    
    if ([JerryTools stringIsNull:contentStr]) {
        
    }else{
        NSMutableDictionary *recordMessage = [NSMutableDictionary dictionary];
        [recordMessage setObject:GROWUP_RECORD_FREEDOM forKey:@"recordSourceTypeKey"];
        [recordMessage setObject:GROWUP_INITIATIVE forKey:@"recordTypeKey"];
        [recordMessage setObject:self.uploadText.text forKey:@"recordContent"];
        [recordMessage setObject:GROWUP_RECORD_PUBLIC_ALL forKey:@"publicTypeKey"];
        [recordMessage setObject:GROWUP_RECORD_PUBLIC_TYPE_PUBLIC forKey:@"recordPublishTypeKey"];
        
        //详细，照片
        [self.viewModel sendRecord:recordMessage andCallback:^(NSDictionary *resultDic) {
            NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
            if (errorMessage) {
                //error
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [JerryViewTools showCZToastInViewController:self andText:errorMessage];
                });
            }else{
                id result = [resultDic objectForKey:RESULT_KEY_DATA];
            }
        }];
    }
}

- (void)initData{
    self.viewModel = [[TrackUploadModel alloc] init];
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
