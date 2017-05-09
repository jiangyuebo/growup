//
//  ExperienceViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/15.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "ExperienceViewController.h"
#import "JerryTools.h"
#import "UserInfoModel.h"
#import "KidInfoModel.h"
#import "ExperienceViewModel.h"
#import "globalHeader.h"
#import "JerryViewTools.h"

@interface ExperienceViewController ()

@property (strong, nonatomic) IBOutlet UILabel *companyTime;

@property (strong, nonatomic) IBOutlet UILabel *companyRante;

@property (strong,nonatomic) ExperienceViewModel *viewModel;

@end

@implementation ExperienceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //显示陪伴时间和陪伴等级
    UserInfoModel *userInfoMode = [JerryTools getUserInfoModel];
    KidInfoModel *child = [[userInfoMode childArray] objectAtIndex:userInfoMode.currentSelectedChild];
    if (child) {
        //陪伴时间
        NSNumber *companyTime = [child accompanyTime];
        self.companyTime.text = [NSString stringWithFormat:@"%@",companyTime];
        
        //陪伴等级
        NSNumber *companyRate = [child accompanyRate];
        self.companyRante.text = [NSString stringWithFormat:@"打败了全国%@%%的家长哦~",companyRate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initView];
}

- (void)initView{
    
}

- (void)initData{
    self.viewModel = [[ExperienceViewModel alloc] init];
    
    //获取体验体验内容列表
    [self getExperienceList];
}

- (void)getExperienceList{
    UserInfoModel *userInfoMode = [JerryTools getUserInfoModel];
    KidInfoModel *child = [[userInfoMode childArray] objectAtIndex:userInfoMode.currentSelectedChild];
    
    if (child) {
        [self.viewModel getExperiencesListByAgeType:[child ageTypeKey] andExperienceType:EXPERIENCE_GAME andPageIndex:[NSNumber numberWithInt:1] andPageSize:[NSNumber numberWithInt:4] andCallback:^(NSDictionary *resultDic) {
            
            NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
            if (errorMessage) {
                //error
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [JerryViewTools showCZToastInViewController:self andText:errorMessage];
                });
            }else{
                NSArray *experienceArray = [resultDic objectForKey:RESULT_KEY_DATA];
                NSLog(@"experienceArray count : %ld",(unsigned long)[experienceArray count]);
            }
        }];
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
