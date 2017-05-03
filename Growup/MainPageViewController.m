//
//  MainPageViewController.m
//  Growup
//
//  Created by Jerry on 2017/2/5.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "MainPageViewController.h"
#import "globalHeader.h"
#import "JerryViewTools.h"
#import "UIColor+NSString.h"
#import "MainPageViewModel.h"
#import "JerryAnimation.h"
#import "JerryTools.h"
#import "UserInfoModel.h"
#import "KidInfoModel.h"
#import "AbilityModel.h"
#import "PopInfoModel.h"

//娃娃脸图片点击跳转tag
#define face_health 10//健康
#define face_society 11//社会
#define face_language 12//语言
#define face_science 13//科学
#define face_art 14//艺术

@interface MainPageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *mainBackgroundView;

@property (strong, nonatomic) MainPageViewModel *viewModel;

//健康笑脸
@property (strong, nonatomic) IBOutlet UIImageView *imageFaceHealth;

//社会笑脸
@property (strong, nonatomic) IBOutlet UIImageView *imageFaceSociety;

//语言笑脸
@property (strong, nonatomic) IBOutlet UIImageView *imageFaceLanguage;

//科学笑脸
@property (strong, nonatomic) IBOutlet UIImageView *imageFaceScience;

//艺术笑脸
@property (strong, nonatomic) IBOutlet UIImageView *imageFaceArt;

//气泡背景
@property (strong, nonatomic) IBOutlet UIImageView *bubbleBackground;

//气泡文字
@property (strong, nonatomic) IBOutlet UILabel *bubbleLabel;

//宝贝年龄字符串（未登录显示“登录”）
@property (strong, nonatomic) IBOutlet UILabel *avatarLabel;

@property (strong, nonatomic) IBOutlet UIView *middleView;

//任务进度条
@property (strong, nonatomic) IBOutlet UISlider *taskProgress;

//橙娃气泡信息
@property (strong,nonatomic) NSMutableArray *popArray;

@property (strong, nonatomic) IBOutlet UIButton *btnReport;

@end

@implementation MainPageViewController

int popIndex = 0;

bool isClick = true;

bool isBubbleShowed = false;

- (IBAction)avatarClicked:(UIButton *)sender {
    //跳转到登录界面
    [JerryViewTools jumpFrom:self ToViewController:IdentifyNameLoginViewController];
}

- (IBAction)changeDemo:(UIButton *)sender {
    UIView *blockView = [self.view viewWithTag:2];
    if (isClick) {
        [self.mainBackgroundView setImage:[UIImage imageNamed:@"bg_night"]];
        blockView.backgroundColor = [UIColor colorWithString:@"#1e4b8e"];
        
        isClick = false;
    }else{
        [self.mainBackgroundView setImage:[UIImage imageNamed:@"bg_day"]];
        blockView.backgroundColor = [UIColor colorWithString:@"#6aa71b"];
        
        isClick = true;
    }
}

#pragma mark 跳转到 测试/详细报告
- (IBAction)testOrReportBtn:(UIButton *)sender {
    if (self.viewModel.needTest) {
        //开始测评
        [JerryViewTools jumpFrom:self ToViewController:IdentifyFastTestViewController];
    }else{
        //查看综合报告
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBar];
    
    [self mainPageUpdage];
}

- (void)initView{
    
    self.title = @"首页";
    
    //设置VIEW圆角
    UIView *targetView = [self.view viewWithTag:1];
    [self setViewRoundCorner:targetView];
    
    //设置中间view绿色
    [self.middleView setBackgroundColor:[UIColor colorWithString:@"#6aa71b"]];
    
    //为笑脸图标添加点击事件
    [self setFaceInteractionEnable];
    
    //为橙宝添加点击事件
    [self setOrangeBabyInteractionEnable];
    //隐藏气泡
    [self hideBubble];
    
    //进度条设置
    [self.taskProgress setMaximumTrackImage:[UIImage imageNamed:@"progress_grey"] forState:UIControlStateNormal];
    [self.taskProgress setMinimumTrackImage:[UIImage imageNamed:@"progress_color"] forState:UIControlStateNormal];
    [self.taskProgress setThumbImage:[UIImage imageNamed:@"progress_title"] forState:UIControlStateNormal];

    self.btnReport.titleLabel.text = @"test";
}

- (void)hideNavigationBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initData{
    //初始化 数据模型
    self.viewModel = [[MainPageViewModel alloc] init];
    
    //创建气泡信息
    self.popArray = [[NSMutableArray alloc] init];
    
    //绑定VIEW与MODEL
    [self modelBinding];
    
}

- (void)mainPageUpdage{
    //判断当前是否有用户数据
    UserInfoModel *currentUser = [JerryTools getUserInfoModel];
    
    if ([currentUser userID]) {
        //有数据
        //
        NSArray *childArray = [currentUser childArray];
        
        if ([childArray count] > 0) {
            
            KidInfoModel *childModel = childArray[currentUser.currentSelectedChild];
            
            NSDictionary *birthdayDic = [childModel birthdayDic];
            
            NSNumber *month = [birthdayDic objectForKey:@"month"];
            NSNumber *year = [birthdayDic objectForKey:@"year"];
            NSNumber *day = [birthdayDic objectForKey:@"day"];
            int yearInt = [year intValue];
            int monthInt = [month intValue];
            
            NSString *birthdayStr;
            
            if (yearInt == 0 && monthInt == 0) {
                //出生年月都是0
                birthdayStr = [NSString stringWithFormat:@"%@天",day];
            }else{
                birthdayStr = [NSString stringWithFormat:@"%@岁%@个月",year,month];
            }
            self.avatarLabel.text = birthdayStr;
            
            [self fetchDataFromServer];
        }
    }else{
        //无数据，显示未登录状态UI
        //判断是否满足免登条件
        if ([JerryTools readInfo:SAVE_KEY_ACCESS_TOKEN]) {
            //有access token,发起请求
            
        }else{
            //无access token
        }
        
        NSLog(@"无数据");
        self.avatarLabel.text = @"登录";
        
        //设置娃娃头为默认图片
        UIImage *defaultImage = [UIImage imageNamed:@"face_mark"];
        
        [self.imageFaceHealth setImage:defaultImage];
        [self.imageFaceSociety setImage:defaultImage];
        [self.imageFaceLanguage setImage:defaultImage];
        [self.imageFaceScience setImage:defaultImage];
        [self.imageFaceArt setImage:defaultImage];
    }

}

- (void)fetchDataFromServer{
    UserInfoModel *currentUser = [JerryTools getUserInfoModel];
    NSArray *childArray = [currentUser childArray];
    if ([childArray count] > 0) {
        //如果有孩子数据
        KidInfoModel *kidModel = childArray[currentUser.currentSelectedChild];
        
        //获取气泡信息
        NSNumber *tempId = [NSNumber numberWithInt:1];
        [self.viewModel queryOrangePopInfoById:kidModel.childID andDynamicId:tempId andCallBack:^(NSDictionary *resultDic) {
            NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
            if (errorMessage) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [JerryViewTools showCZToastInViewController:self andText:errorMessage];
                });
            }else{
                NSArray *popInfoArray = [resultDic objectForKey:RESULT_KEY_DATA];
                [self.popArray addObjectsFromArray:popInfoArray];
            }
        }];
        
        //获取孩子首页数据
//        [self.viewModel queryChildStatusInfoByChildId:kidModel.childID andAgeType:kidModel.ageTypeKey andCallback:^(NSDictionary *resultDic) {
//            NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
//            if (errorMessage) {
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [JerryViewTools showCZToastInViewController:self andText:errorMessage];
//                });
//            }else{
//                AbilityModel *abilityModel = [resultDic objectForKey:RESULT_KEY_DATA];
//                BOOL isAbilityExpired = [abilityModel isAbilityExpired];
//                NSString *buttonStr;
//                if (isAbilityExpired) {
//                    //需要测评
//                    buttonStr = @"开始测评";
//                    self.viewModel.needTest = YES;
//                }else{
//                    //不需要测评
//                    buttonStr = @"详细报告";
//                    self.viewModel.needTest = NO;
//                }
//                
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [self.btnReport setTitle:buttonStr forState:UIControlStateNormal];
//                    
//                    [self setAbilityStatus:abilityModel];
//                });
//            }
//        }];
        
        
        //获取行动项
//        [self.viewModel queryActionListByAgeType:kidModel.ageTypeKey andActionDate:[NSDate date] andIsRefresh:NO andCallback:^(NSDictionary *resultDic) {
//            NSLog(@"its back");
//        }];
    }

}

#pragma mark 设置
- (void)setAbilityStatus:(AbilityModel *) abilityMode{
    
    NSString *indexArtStatusTypeKey = [abilityMode indexArtStatusTypeKey];
    [self.imageFaceArt setImage:[self rankImageFromParam:indexArtStatusTypeKey]];
    
    NSString *indexHealthStatusTypeKey = [abilityMode indexHealthStatusTypeKey];
    [self.imageFaceHealth setImage:[self rankImageFromParam:indexHealthStatusTypeKey]];
    
    NSString *indexLanguageStatusTypeKey = [abilityMode indexLanguageStatusTypeKey];
    [self.imageFaceLanguage setImage:[self rankImageFromParam:indexLanguageStatusTypeKey]];
    
    NSString *indexScienceStatusTypeKey = [abilityMode indexScienceStatusTypeKey];
    [self.imageFaceScience setImage:[self rankImageFromParam:indexScienceStatusTypeKey]];
    
    NSString *indexSociologyStatusTypeKey = [abilityMode indexSociologyStatusTypeKey];
    [self.imageFaceSociety setImage:[self rankImageFromParam:indexSociologyStatusTypeKey]];
}

- (UIImage *)rankImageFromParam:(NSString *) param{
    if ([param isEqualToString:VALUE_NORMAL]) {
        UIImage *normal = [UIImage imageNamed:@"notgood"];
        return normal;
    }
    
    if ([param isEqualToString:VALUE_GOOD]) {
        UIImage *good = [UIImage imageNamed:@"good"];
        return good;
    }
    
    if ([param isEqualToString:VALUE_VERYGOOD]) {
        UIImage *veryGood = [UIImage imageNamed:@"verygood"];
        return veryGood;
    }
    
    return nil;
}

//为娃娃脸设置点击事件
- (void)setFaceInteractionEnable{
    
    NSArray *faceImageViewArray = [[NSArray alloc] initWithObjects:
                                   self.imageFaceHealth,
                                   self.imageFaceSociety,
                                   self.imageFaceLanguage,
                                   self.imageFaceScience,
                                   self.imageFaceArt,
                                   nil];
    
    for (int i = 0; i < [faceImageViewArray count]; i++) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceClicked:)];
        UIImageView *faceImageView = [faceImageViewArray objectAtIndex:i];
        faceImageView.userInteractionEnabled = YES;
        faceImageView.tag = i + 10;
        [faceImageView addGestureRecognizer:singleTap];
    }
}

//为橙娃添加点击事件
- (void)setOrangeBabyInteractionEnable{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orangeBabyClicked)];
    self.orangeBaby.userInteractionEnabled = YES;
    [self.orangeBaby addGestureRecognizer:singleTap];
}

//点击娃娃脸的跳转
- (void)faceClicked:(UITapGestureRecognizer *) recognizer{
    
    switch (recognizer.view.tag) {
        case face_health:
            NSLog(@"健康");
            [JerryViewTools jumpFrom:self ToViewController:IdentifyNameAbilityExplainViewController];
            break;
            
        case face_society:
            NSLog(@"社会");
            [JerryViewTools jumpFrom:self ToViewController:IdentifyNameSocietyExplainViewController];
            break;
            
        case face_language:
            NSLog(@"语言");
            break;
            
        case face_science:
            NSLog(@"科学");
            break;
            
        case face_art:
            NSLog(@"艺术");
            break;
    }
}

- (void)orangeBabyClicked{
    if (!isBubbleShowed) {
        [JerryAnimation shakeToShow:self.orangeBaby];
        //弹出一句话
        [self showBubble];
        //3秒后消失
        [self performSelector:@selector(hideBubble) withObject:nil afterDelay:3.0];
        
    }
}

//气泡出现
- (void)showBubble{
    if ([self.popArray count] > 0) {
        if (popIndex > ([self.popArray count] - 1)) {
            popIndex = 0;
        }
        
        PopInfoModel *popInfo = [self.popArray objectAtIndex:popIndex];
        NSString *contentInfo = [popInfo infoDescription];
        if ([JerryTools stringIsNull:contentInfo]) {
            self.bubbleLabel.text = [popInfo infoName];
        }else{
            self.bubbleLabel.text = contentInfo;
        }
        
        popIndex++;
        
        self.bubbleBackground.hidden = NO;
        self.bubbleLabel.hidden = NO;
        isBubbleShowed = true;
    }
}

//隐藏气泡
- (void)hideBubble{
    self.bubbleBackground.hidden = YES;
    self.bubbleLabel.hidden = YES;
    isBubbleShowed = false;
}

//设置view圆角
- (void)setViewRoundCorner:(UIView *) view{
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
}

//绑定VIEW与MODEL
- (void)modelBinding{
//    [self.viewModel addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionNew context:nil];
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
