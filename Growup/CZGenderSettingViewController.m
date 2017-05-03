//
//  CZGenderSettingViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/20.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZGenderSettingViewController.h"
#import "globalHeader.h"
#import "JerryViewTools.h"

@interface CZGenderSettingViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *boyImageView;

@property (strong, nonatomic) IBOutlet UIImageView *girlImageView;


@end

@implementation CZGenderSettingViewController

@synthesize passDataDic;

- (IBAction)saveGender:(UIButton *)sender {
    [JerryViewTools jumpFrom:self ToViewController:IdentifyNameInterestSettingViewController carryDataDic:self.passDataDic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView{
    //设置性别按钮点击事件
    [self setGenderImageClickable];
    
    //设置默认选择男孩
    [self setBoySelected];
}

- (void)setGenderImageClickable{
    
    self.boyImageView.userInteractionEnabled = YES;
    self.girlImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap_boy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(genderImageViewClick:)];
    
    UITapGestureRecognizer *singleTap_girl = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(genderImageViewClick:)];
    
    [self.boyImageView addGestureRecognizer:singleTap_boy];
    [self.girlImageView addGestureRecognizer:singleTap_girl];
}

- (void)genderImageViewClick:(UITapGestureRecognizer *) sender{
    UIImageView *genderImageView = (UIImageView *)sender.view;
    if (genderImageView == self.boyImageView) {
        //男孩
        [self setBoySelected];
    }else{
        //女孩
        [self setGirlSelected];
    }
}

- (void)setBoySelected{
    [self.boyImageView setImage:[UIImage imageNamed:@"boy_hover"]];
    [self.girlImageView setImage:[UIImage imageNamed:@"girl"]];
    
    NSNumber *sex = [NSNumber numberWithInt:1];
    
    [self.passDataDic setObject:sex forKey:COLUMN_SEX];
}

- (void)setGirlSelected{
    [self.boyImageView setImage:[UIImage imageNamed:@"boy"]];
    [self.girlImageView setImage:[UIImage imageNamed:@"girl_hover"]];
    
    NSNumber *sex = [NSNumber numberWithInt:2];
    
    [self.passDataDic setObject:sex forKey:COLUMN_SEX];
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
