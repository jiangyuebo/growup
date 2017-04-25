//
//  CZBirthdaySettingViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/20.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZBirthdaySettingViewController.h"
#import "globalHeader.h"
#import "JerryViewTools.h"
#import "CZGenderSettingViewController.h"

@interface CZBirthdaySettingViewController ()

@property (strong, nonatomic) IBOutlet UIDatePicker *babyBirthdayPicker;


@property (strong, nonatomic) IBOutlet UILabel *birthDataSetting;

@property (strong,nonatomic) NSMutableDictionary *passDataDic;

@end

@implementation CZBirthdaySettingViewController

- (IBAction)finishBirthdaySetting:(UIButton *)sender {
    
    NSDate *birthDate = [self.babyBirthdayPicker date];
    [self.passDataDic setObject:birthDate forKey:COLUMN_BIRTHDAY];
    
    [JerryViewTools jumpFrom:self ToViewController:IdentifyGenderSettingViewController carryDataDic:self.passDataDic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
}

- (void)initView{
    [self.babyBirthdayPicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self setBirthDateValue];
}

- (void)initData{
    self.passDataDic = [NSMutableDictionary dictionary];
}

#pragma mark DatePicker View 绑定事件
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {
    [self setBirthDateValue];
}

#pragma mark 设置生日文本显示值
- (void)setBirthDateValue{
    NSDate *selectedDate = [self.babyBirthdayPicker date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [dateFormatter stringFromDate:selectedDate];
    
    self.birthDataSetting.text = dateStr;
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
