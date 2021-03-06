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
#import "ActionCell.h"
#import "ActionCellButton.h"
#import "ActionExpCell.h"
#import "ActionSciCell.h"
#import "PersonInfoViewController.h"
#import "PersonCenterViewController.h"
#import "ExperienceDetailViewController.h"
#import <AVFoundation/AVFoundation.h>

//娃娃脸图片点击跳转tag
#define face_health 10//健康
#define face_society 11//社会
#define face_language 12//语言
#define face_science 13//科学
#define face_art 14//艺术

@interface MainPageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *mainBackgroundView;

@property (strong, nonatomic) MainPageViewModel *viewModel;

//首页数据集
@property (strong,nonatomic) NSDictionary *abilityModel;

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

//进度条所在view
@property (strong, nonatomic) IBOutlet UIView *progressView;

//完成度文字
@property (strong, nonatomic) IBOutlet UILabel *finishPercentLabel;

//任务进度条
@property (strong, nonatomic) IBOutlet UISlider *taskProgress;

//橙娃气泡信息
@property (strong,nonatomic) NSMutableArray *popArray;

@property (strong, nonatomic) IBOutlet UIButton *btnReport;

@property (strong, nonatomic) IBOutlet UITableView *actionTable;

//为查询测评结果准备数据，userAbilityId
@property (strong,nonatomic) NSNumber *userAbilityId;

//行动项数据
@property (strong,nonatomic) NSDictionary *actionInfoDic;

//行动项列表数据
@property (strong,nonatomic) NSMutableArray *actionTableItems;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *actionTableHeight;

//行动卡片播放器
@property (strong,nonatomic) AVPlayer *actionPlayer;
@property (nonatomic) BOOL isPlaying;
@property (strong,nonatomic) id timeObserve;

@property (strong,nonatomic) ActionCellButton *actionCellButton;

//所有播放按钮
@property (strong,nonatomic) NSMutableArray *allActionButtons;

@property (strong,nonatomic) NSTimer *timer;

@property (strong,nonatomic) UIScrollView *scrollViewForGuidancePage;

@property (strong,nonatomic) UIPageControl *pageControlForGuidancePage;

@property (strong,nonatomic) UIButton *buttonForStart;

@end

@implementation MainPageViewController

int popIndex = 0;

bool isClick = true;

bool isBubbleShowed = false;

- (IBAction)avatarClicked:(UIButton *)sender {
    //判断当前是否有用户数据
    UserInfoModel *currentUser = [JerryTools getUserInfoModel];
    
    if ([currentUser userID]) {
        //有用户
        PersonCenterViewController *personCenterViewController = [JerryViewTools getViewControllerById:IdentifyNamePersonCenterTableViewController];
        
        [self.navigationController pushViewController:personCenterViewController animated:YES];
        
        //TEST
//        [JerryViewTools jumpFrom:self ToViewController:IdentifyNameInterestSettingViewController carryDataDic:nil];
    }else{
        //无用户
        //跳转到登录界面
        [JerryViewTools jumpFrom:self ToViewController:IdentifyNameLoginViewController];
    }
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
    //test
//    [JerryViewTools jumpFrom:self ToViewController:IdentifyNameDetailReportViewController];
    
    if (self.viewModel.needTest) {
        //开始测评
        [JerryViewTools jumpFrom:self ToViewController:IdentifyFastTestViewController];
    }else{
        //查看综合报告
        [JerryViewTools jumpFrom:self ToViewController:IdentifyNameDetailReportViewController];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createGuidancePage];
    
    [self initData];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBar];
    
//    self.tabBarController.tabBar.hidden = NO;
    
    [self mainPageUpdage];
}

#pragma mark 橙子跳
- (void)orangeJump{
    //设置橙娃动画 orange_1
    self.orangeBaby.image = [UIImage animatedImageNamed:@"orange_" duration:0.7];
}

#pragma mark 橙娃不跳
- (void)orangeStop{
    //设置橙娃动画 orange_1
    self.orangeBaby.image = [UIImage imageNamed:@"orange_1"];
}

- (void)initView{
    
    self.title = @"首页";
    
    //设置橙娃动画 orange_1
    self.orangeBaby.image = [UIImage animatedImageNamed:@"orange_" duration:0.7];
    
    [self performSelector:@selector(orangeStop) withObject:nil afterDelay:5.0f];
    
    //设置VIEW圆角
    UIView *targetView = [self.view viewWithTag:1];
    [self setViewRoundCorner:targetView];
    
    //设置中间view绿色
    [self.middleView setBackgroundColor:[UIColor colorWithString:@"#6aa71b"]];
    
    //设置进度条view颜色
    [self.progressView setBackgroundColor:[UIColor colorWithString:@"#6aa71b"]];
    
    //为笑脸图标添加点击事件
    [self setFaceInteractionEnable];
    
    //为橙宝添加点击事件
    [self setOrangeBabyInteractionEnable];
    //隐藏气泡
    [self hideBubble];
    
    //进度条设置
    UIImage *leftTrack = [[UIImage imageNamed:@"progress_color"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    UIImage *rightTrack = [[UIImage imageNamed:@"progress_white"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    
    [self.taskProgress setMinimumTrackImage:leftTrack forState:UIControlStateNormal];
    [self.taskProgress setMaximumTrackImage:rightTrack forState:UIControlStateNormal];
    [self.taskProgress setThumbImage:[UIImage imageNamed:@"progress_icon"] forState:UIControlStateNormal];
    
    self.taskProgress.userInteractionEnabled = NO;
    
    self.btnReport.titleLabel.text = @"test";
    
    //初始化播放器
    self.actionPlayer = [[AVPlayer alloc] init];
}

#pragma mark 获得加上数字的滑块图片
- (UIImage *)getNumberedThumbImage:(NSNumber *) number{
    
    UIImage *originImage = [UIImage imageNamed:@"progress_icon"];
    NSString *numberStr = [NSString stringWithFormat:@"%@",number];
    UIImage *numberedImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, 0.0);
    [originImage drawAtPoint: CGPointZero];
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName,[UIColor darkGrayColor],NSForegroundColorAttributeName, nil];
    [numberStr drawAtPoint:CGPointMake(7,-1) withAttributes:attrs];
    numberedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return numberedImage;
}

- (void)hideNavigationBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initData{
    
    //初始化 数据模型
    self.viewModel = [[MainPageViewModel alloc] init];
    
    //创建气泡信息
    self.popArray = [[NSMutableArray alloc] init];
    
    //所有播放按钮的
    self.allActionButtons = [[NSMutableArray alloc] init];
    
    self.actionTableItems = [[NSMutableArray alloc] init];
    self.actionTable.dataSource = self;
    self.actionTable.delegate = self;
    
    self.actionTable.separatorStyle = NO;
    self.actionTable.scrollEnabled = NO;
    self.actionTable.allowsSelection = NO;
    
    //播放状态
    self.isPlaying = NO;
}

#pragma mark 判断是否有孩子数据
- (BOOL)hasChild{
    UserInfoModel *currentUser = [JerryTools getUserInfoModel];
    if ([currentUser userID]) {
        NSArray *childArray = [currentUser childArray];
        if ([childArray count] > 0) {
            
            [self formatBirthdayLabel];
            
            [self fetchDataFromServer];
            
            return YES;
        }else{
            //有用户数据但无孩子数据，弹出添加孩子信息界面 IdentifyNameBirthdaySettingViewController
            [JerryViewTools jumpFrom:self ToViewController:IdentifyNameBirthdaySettingViewController];
            
            return NO;
        }
    }else{
        return NO;
    }
    
}

- (void)mainPageUpdage{
    //判断当前是否有用户数据
    UserInfoModel *currentUser = [JerryTools getUserInfoModel];
    
    if ([currentUser userID]) {
        //有数据
        //
        NSArray *childArray = [currentUser childArray];
        
        if ([childArray count] > 0) {
            
            [self formatBirthdayLabel];
            
            [self fetchDataFromServer];
        }else{
            //有用户数据但无孩子数据，弹出添加孩子信息界面 IdentifyNameBirthdaySettingViewController
            [JerryViewTools jumpFrom:self ToViewController:IdentifyNameBirthdaySettingViewController];
        }
    }else{
        //无数据，显示未登录状态UI
        //判断是否满足免登条件
        NSString *accessToken = [JerryTools readInfo:SAVE_KEY_ACCESS_TOKEN];
        if (accessToken) {
            //有access token,发起请求
            [self.viewModel getUserInfoByAccesstoken:accessToken andCallback:^(NSDictionary *resultDic) {
                NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
                if (errorMessage) {
                    //error
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [JerryViewTools showCZToastInViewController:self andText:errorMessage];
                    });
                }else{
                    NSString *result = [resultDic objectForKey:RESULT_KEY_DATA];
                    if ([result isEqualToString:@"success"]) {
                        //数据加载完成
                        //生日显示
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self formatBirthdayLabel];
                            
                            //判断是否有孩子数据
                            [self hasChild];
                        });
                    }
                }
            }];
        }else{
            //无access token
            NSLog(@"无数据");
            self.avatarLabel.text = @"登录";
            
            //设置娃娃头为默认图片
            UIImage *defaultImage = [UIImage imageNamed:@"face_mark"];
            
            [self.imageFaceHealth setImage:defaultImage];
            [self.imageFaceSociety setImage:defaultImage];
            [self.imageFaceLanguage setImage:defaultImage];
            [self.imageFaceScience setImage:defaultImage];
            [self.imageFaceArt setImage:defaultImage];
            
            //设置行动项列表不显示
            self.actionTableHeight.constant = 0;
            //设置行动完成进度条
            [self.taskProgress setValue:0];
        }
    }

}

- (void)formatBirthdayLabel{
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
            int dayInt = [day intValue];
            
            NSString *birthdayStr;
            
            if (yearInt == 0 && monthInt == 0) {
                //出生年月都是0
                birthdayStr = [NSString stringWithFormat:@"%@天",day];
            }
            
            if (yearInt == 0 && monthInt != 0 && dayInt != 0) {
                birthdayStr = [NSString stringWithFormat:@"%@月%@天",month,day];
            }
            
            if (yearInt != 0 && monthInt != 0 && dayInt == 0) {
                birthdayStr = [NSString stringWithFormat:@"%@岁%@个月",year,month];
            }
            
            if (yearInt != 0 && monthInt == 0 && dayInt != 0) {
                birthdayStr = [NSString stringWithFormat:@"%@岁零%@天",year,day];
            }
            
            if (yearInt != 0 && monthInt != 0 && dayInt != 0) {
                birthdayStr = [NSString stringWithFormat:@"%@岁%@月零%@天",year,month,day];
            }
            
            self.avatarLabel.text = birthdayStr;
        }
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
                if ([popInfoArray count] > 0) {
                    [self.popArray addObjectsFromArray:popInfoArray];
                }
            }
        }];
        
        //获取孩子首页数据
        [self.viewModel queryChildStatusInfoByChildId:kidModel.childID andAgeType:kidModel.ageTypeKey andCallback:^(NSDictionary *resultDic) {
            NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
            if (errorMessage) {
                //error
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [JerryViewTools showCZToastInViewController:self andText:errorMessage];
                });
            }else{
                self.abilityModel = [resultDic objectForKey:RESULT_KEY_DATA];
                
                //获取各能力分数
                NSNumber *indexArtScore = [self.abilityModel objectForKey:@"indexArtScore"];
                int artInt = 0;
                if (indexArtScore) {
                    artInt = [indexArtScore intValue];
                }
                
                NSNumber *indexHealthScore = [self.abilityModel objectForKey:@"indexHealthScore"];
                int healthInt = 0;
                if (indexHealthScore) {
                    healthInt = [indexHealthScore intValue];
                }
                
                NSNumber *indexLanguageScore = [self.abilityModel objectForKey:@"indexLanguageScore"];
                int languageInt = 0;
                if (indexLanguageScore) {
                    languageInt = [indexLanguageScore intValue];
                }
                
                NSNumber *indexScienceScore = [self.abilityModel objectForKey:@"indexScienceScore"];
                int scienceInt = 0;
                if (indexScienceScore) {
                    scienceInt = [indexScienceScore intValue];
                }
                
                NSNumber *indexSociologyScore = [self.abilityModel objectForKey:@"indexSociologyScore"];
                int sociologyInt = 0;
                if (indexSociologyScore) {
                    sociologyInt = [indexSociologyScore intValue];
                }
                
                NSString *buttonStr;
                if (artInt == 0 && healthInt == 0 && languageInt == 0 && scienceInt == 0 && sociologyInt == 0) {
                    //全部分数为0，总体测试按钮为测试
                    buttonStr = @"开始测评";
                    self.viewModel.needTest = YES;
                }else{
                    //总体测试按钮为查看总体报告
                    buttonStr = @"详细报告";
                    self.viewModel.needTest = NO;
                }
                
                //获取user ability id
                self.userAbilityId = [self.abilityModel objectForKey:@"userAbilityID"];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.btnReport setTitle:buttonStr forState:UIControlStateNormal];
                    
                    [self setAbilityStatus:self.abilityModel];
                });
            }
        }];
        
        if ([self.actionTableItems count] == 0) {
            //获取行动项
            [self.viewModel queryActionListByAgeType:kidModel.ageTypeKey andActionDate:[NSDate date] andIsRefresh:NO andCallback:^(NSDictionary *resultDic) {
                
                NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
                if (errorMessage) {
                    //error
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [JerryViewTools showCZToastInViewController:self andText:errorMessage];
                    });
                }else{
                    self.actionInfoDic = [resultDic objectForKey:RESULT_KEY_DATA];
                    
                    //获取行动项个数及完成数
                    NSNumber *actionFinishNumber = [self.actionInfoDic objectForKey:@"actionFinishNumber"];
                    NSNumber *actionNumber = [self.actionInfoDic objectForKey:@"actionNumber"];
                    
                    //获取行动项
                    NSArray *userActionSubjects = [self.actionInfoDic objectForKey:@"userActionSubjects"];
                    NSArray *userActionTasks = [self.actionInfoDic objectForKey:@"userActionTasks"];
                    NSArray *userActionExperiences = [self.actionInfoDic objectForKey:@"userActionExperiences"];
                    
                    [self.actionTableItems addObjectsFromArray:userActionSubjects];
                    [self.actionTableItems addObjectsFromArray:userActionTasks];
                    [self.actionTableItems addObjectsFromArray:userActionExperiences];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.taskProgress setMaximumValue:[actionNumber floatValue]];
                        [self.taskProgress setMinimumValue:0];
                        [self.taskProgress setValue:[actionFinishNumber floatValue]];
                        
                        UIImage *numberedImage = [self getNumberedThumbImage:actionFinishNumber];
                        [self.taskProgress setThumbImage:numberedImage forState:UIControlStateNormal];
                        
                        [self.actionTable reloadData];
                        
                        //设置完成度文字提示
                        int finishint = [actionFinishNumber intValue];
                        if (finishint == 0) {
                            self.finishPercentLabel.text = [NSString stringWithFormat:@"今日行动完成度：0%%"];
                        }else{
                            int temp = (int)([actionFinishNumber floatValue]/[actionNumber floatValue] * 100);
                            self.finishPercentLabel.text = [NSString stringWithFormat:@"今日行动完成度：%d%%",temp];
                        }
                        
                        //重设列表高度
                        [self resetActionTableHeight];
                    });
                }
            }];
        }
    }
}

#pragma mark 重设行动项列表高度
- (void) resetActionTableHeight{
    CGFloat height = 0;
    for (int i = 0; i < [self.actionTableItems count]; i++) {
        NSDictionary *infoDic = self.actionTableItems[i];
        if ([infoDic objectForKey:@"subject"]) {
            height += Height_Action_Subject_Cell;
        }
        if ([infoDic objectForKey:@"task"]) {
            height += Height_Action_Subject_Cell;
        }
        if ([infoDic objectForKey:@"experience"]) {
            //判断体验类型
            NSString *experienceTypeKey = [[infoDic objectForKey:@"experience"] objectForKey:@"experienceTypeKey"];
            if ([experienceTypeKey isEqualToString:EXPERIENCE_SCIENCE]) {
                height += Height_Action_exp_sci_cell;
            }else{
                height += Height_Action_exp_Cell;
            }
        }
    }
    
    self.actionTableHeight.constant = height;
}

#pragma mark 设置
- (void)setAbilityStatus:(NSDictionary *) abilityMode{
    
    NSString *indexArtStatusTypeKey = [abilityMode objectForKey:@"indexArtStatusTypeKey"];
    [self.imageFaceArt setImage:[self rankImageFromParam:indexArtStatusTypeKey]];
    
    NSString *indexHealthStatusTypeKey = [abilityMode objectForKey:@"indexHealthStatusTypeKey"];
    [self.imageFaceHealth setImage:[self rankImageFromParam:indexHealthStatusTypeKey]];
    
    NSString *indexLanguageStatusTypeKey = [abilityMode objectForKey:@"indexLanguageStatusTypeKey"];
    [self.imageFaceLanguage setImage:[self rankImageFromParam:indexLanguageStatusTypeKey]];
    
    NSString *indexScienceStatusTypeKey = [abilityMode objectForKey:@"indexScienceStatusTypeKey"];
    [self.imageFaceScience setImage:[self rankImageFromParam:indexScienceStatusTypeKey]];
    
    NSString *indexSociologyStatusTypeKey = [abilityMode objectForKey:@"indexSociologyStatusTypeKey"];
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
    
    UIImage *veryGood = [UIImage imageNamed:@"face_mark"];
    return veryGood;
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

#pragma mark 为橙娃添加点击事件
- (void)setOrangeBabyInteractionEnable{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orangeBabyClicked)];
    self.orangeBaby.userInteractionEnabled = YES;
    [self.orangeBaby addGestureRecognizer:singleTap];
}

#pragma mark 点击娃娃脸的跳转
- (void)faceClicked:(UITapGestureRecognizer *) recognizer{
    
    NSMutableDictionary *passDic = [NSMutableDictionary dictionary];
    
    switch (recognizer.view.tag) {
        case face_health:{
            NSLog(@"健康");
            NSNumber *indexHealthScore = [self.abilityModel objectForKey:@"indexHealthScore"];
            int healthScoreInt = [indexHealthScore intValue];
            
            if (healthScoreInt == 0) {
                //开始测评
                [passDic setObject:@"D43B01" forKey:@"abilityID"];
                [JerryViewTools jumpFrom:self ToViewController:IdentifyFastTestViewController carryDataDic:passDic];
            }else{
                //查看综合报告
                [JerryViewTools jumpFrom:self ToViewController:IdentifyNameDetailReportViewController];
            }
        }
        break;
            
        case face_society:{
            NSNumber *indexSociologyScore = [self.abilityModel objectForKey:@"indexSociologyScore"];
            int sociologySocreInt = [indexSociologyScore intValue];
            NSLog(@"社会");
            if (sociologySocreInt == 0) {
                //开始测评
                [passDic setObject:@"D43B02" forKey:@"abilityID"];
                [JerryViewTools jumpFrom:self ToViewController:IdentifyFastTestViewController carryDataDic:passDic];
            }else{
                //查看综合报告
                [JerryViewTools jumpFrom:self ToViewController:IdentifyNameDetailReportViewController];
            }
        }
        break;
            
        case face_language:{
            NSLog(@"语言");
            NSNumber *indexLanguageScore = [self.abilityModel objectForKey:@"indexLanguageScore"];
            int languageScore = [indexLanguageScore intValue];
            
            if (languageScore == 0) {
                //开始测评
                [passDic setObject:@"D43B03" forKey:@"abilityID"];
                [JerryViewTools jumpFrom:self ToViewController:IdentifyFastTestViewController carryDataDic:passDic];
            }else{
                //查看综合报告
                [JerryViewTools jumpFrom:self ToViewController:IdentifyNameDetailReportViewController];
            }
        }
        break;
            
        case face_science:{
            NSLog(@"科学");
            NSNumber *indexScienceScore = [self.abilityModel objectForKey:@"indexScienceScore"];
            int scienceScoreInt = [indexScienceScore intValue];
            if (scienceScoreInt == 0) {
                //开始测评
                [passDic setObject:@"D43B04" forKey:@"abilityID"];
                [JerryViewTools jumpFrom:self ToViewController:IdentifyFastTestViewController carryDataDic:passDic];
            }else{
                //查看综合报告
                [JerryViewTools jumpFrom:self ToViewController:IdentifyNameDetailReportViewController];
            }
        }
        break;
            
        case face_art:{
            NSLog(@"艺术");
            NSNumber *indexArtScore = [self.abilityModel objectForKey:@"indexArtScore"];
            int artScoreInt = [indexArtScore intValue];
            if (artScoreInt == 0) {
                //开始测评
                [passDic setObject:@"D43B05" forKey:@"abilityID"];
                [JerryViewTools jumpFrom:self ToViewController:IdentifyFastTestViewController carryDataDic:passDic];
            }else{
                //查看综合报告
                [JerryViewTools jumpFrom:self ToViewController:IdentifyNameDetailReportViewController];
            }
        }
        break;
    }
}

- (void)orangeBabyClicked{
    //如果气泡无内容，则不进行动作
    if ([self.popArray count] > 0) {
//        if (!isBubbleShowed) {
            [JerryAnimation shakeToShow:self.orangeBaby];
            //弹出一句话
            [self showBubble];
            //3秒后消失
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideBubble) userInfo:nil repeats:NO];
        }else{
            //先取消
            [self.timer invalidate];
            //创建
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideBubble) userInfo:nil repeats:NO];
        }
        
        
//        }
    }
}

//气泡出现
- (void)showBubble{
    if ([self.popArray count] > 0) {
        if (popIndex > ([self.popArray count] - 1)) {
            popIndex = 0;
        }
        
        NSDictionary *popInfo = [self.popArray objectAtIndex:popIndex];
        NSString *contentInfo = [popInfo objectForKey:@"dynamicName"];
        if ([JerryTools stringIsNull:contentInfo]) {
            self.bubbleLabel.text = @"爸爸妈妈每天都要开开心心的哟";
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

#pragma mark 引导页
- (void)createGuidancePage{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"引导页"]) {
    
        [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"引导页"];
        
        self.tabBarController.tabBar.hidden = YES;
        
        NSArray *arrayOfImageView = [NSArray array];
        //引导页图片
        arrayOfImageView = @[@"guide1", @"guide2", @"guide3",@"guide4"];
        
        self.scrollViewForGuidancePage = [[UIScrollView alloc] init];
        
        //添加到window上
        [self.view addSubview:self.scrollViewForGuidancePage];
        
        self.scrollViewForGuidancePage.bounces = NO;
        self.scrollViewForGuidancePage.pagingEnabled = YES;
        self.scrollViewForGuidancePage.showsHorizontalScrollIndicator = NO;
        self.scrollViewForGuidancePage.userInteractionEnabled = YES;
        self.scrollViewForGuidancePage.frame = self.view.frame;
        self.scrollViewForGuidancePage.contentSize = CGSizeMake(self.view.frame.size.width * arrayOfImageView.count, 0);
        self.scrollViewForGuidancePage.delegate = self;
        
        self.pageControlForGuidancePage = [[UIPageControl alloc] init];
        [self.view addSubview:self.pageControlForGuidancePage];
        self.pageControlForGuidancePage.frame = CGRectMake(0, 0, self.view.frame.size.width / 2, 40);
        self.pageControlForGuidancePage.center = CGPointMake(self.scrollViewForGuidancePage.frame.size.width / 2, self.scrollViewForGuidancePage.frame.size.height - 40);
        self.pageControlForGuidancePage.numberOfPages = arrayOfImageView.count;
        
        //for循环, 在scrollView上添加照片
        for (int i = 0; i < arrayOfImageView.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arrayOfImageView[i]]];
            imageView.frame = CGRectMake(self.scrollViewForGuidancePage.frame.size.width * i, 0, self.scrollViewForGuidancePage.frame.size.width, self.scrollViewForGuidancePage.frame.size.height);
            [self.scrollViewForGuidancePage addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            
            if (i == arrayOfImageView.count - 1) {
                //引导页最后一页"开始体验"按钮, 进入APP
                self.buttonForStart = [UIButton buttonWithType:UIButtonTypeCustom];
                [imageView addSubview:self.buttonForStart];
                [self.buttonForStart setTitle:@"开始体验" forState:UIControlStateNormal];
                [self.buttonForStart setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                self.buttonForStart.layer.borderWidth = 1;
                self.buttonForStart.layer.borderColor = [[UIColor orangeColor] CGColor];
                self.buttonForStart.layer.cornerRadius = 7;
                self.buttonForStart.layer.masksToBounds = YES;
                self.buttonForStart.frame = CGRectMake(0, 0, self.view.frame.size.width / 2, 40);
                self.buttonForStart.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 100);
                [self.buttonForStart addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControlForGuidancePage.currentPage = self.scrollViewForGuidancePage.contentOffset.x / self.view.frame.size.width;
    
}

- (void)start {
    
    //从父视图上移除
    [self.pageControlForGuidancePage removeFromSuperview];
    
    [self.scrollViewForGuidancePage removeFromSuperview];
    
    self.tabBarController.tabBar.hidden = NO;
    
}

#pragma mark 行动项播放按钮
- (void)cellActionButtonClicked:(id) sender{
    ActionCellButton *button = (ActionCellButton *)sender;
    
    //所有按钮显示复位
    for (int i = 0; i < [self.allActionButtons count]; i++) {
        ActionCellButton *tempButton = self.allActionButtons[i];
        if (!(tempButton == button)){
            tempButton.isPlaying = NO;
            [tempButton setBackgroundImage:[UIImage imageNamed:@"action_play"] forState:UIControlStateNormal];
        }
    }
    
    if (button.isPlaying) {
        //正在播放，停止
        [self.actionPlayer pause];
        button.isPlaying = NO;
        [button setBackgroundImage:[UIImage imageNamed:@"action_play"] forState:UIControlStateNormal];
    }else{
        //未播放，开始播放
        NSUInteger row = button.rowIndex;
        
        button.enabled = NO;
        button.isPlaying = YES;
        
        //加载等待效果
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:button.bounds];
        [indicator setUserInteractionEnabled:YES];
        [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [indicator setColor:[UIColor orangeColor]];
        [indicator hidesWhenStopped];
        
        [button addSubview:indicator];
        [indicator startAnimating];
        
        //获取待播放对象
        NSDictionary *infoDic = [self.actionTableItems objectAtIndex:row];
        NSDictionary *expDic = [infoDic objectForKey:@"experience"];
        NSString *urlStr = [expDic objectForKey:@"contentResourceUrl"];
        if (urlStr) {
            AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:urlStr] options:nil];
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
            
            [self playActionResource:playerItem andButton:button andIndicator:indicator];
        }
    }
}

#pragma mark 播放
- (void)playActionResource:(AVPlayerItem *) playerItem andButton:(UIButton *)button andIndicator:(UIActivityIndicatorView *) indicator{
    if (self.actionPlayer.currentItem) {
        [self.actionPlayer replaceCurrentItemWithPlayerItem:playerItem];
    }else{
        self.actionPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    }
    [self.actionPlayer play];
    
    __block BOOL stopShowFlag = NO;
    __block ActionCellButton *blockActionButton = (ActionCellButton *)button;
    
    //播放进度监听
    self.timeObserve = [self.actionPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        float current = CMTimeGetSeconds(time);
//        float total = CMTimeGetSeconds(playerItem.duration);
        
        if (current) {
            //开始播放
            if (!stopShowFlag) {
                NSLog(@"修改按钮状态");
                [indicator stopAnimating];
                blockActionButton.enabled = YES;
                blockActionButton.isPlaying = YES;
                [blockActionButton setBackgroundImage:[UIImage imageNamed:@"action_stop"] forState:UIControlStateNormal];

                stopShowFlag = YES;
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
}

#pragma mark 播放完成广播
- (void)playbackFinished:(NSNotification *)notice {
    NSLog(@"播放完成");
    self.actionCellButton.enabled = YES;
}

//设置view圆角
- (void)setViewRoundCorner:(UIView *) view{
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
}

#pragma mark 点击行动项CELL中的按钮
- (void)cellButtonClicked:(id) sender{
    ActionCellButton *button = (ActionCellButton *)sender;
    NSUInteger tag = button.tag;
    NSUInteger row = button.rowIndex;
    
    NSIndexPath *indexPath = button.indexPath;
    
    //获取行动项对象
    NSDictionary *clickedItem = [self.actionTableItems objectAtIndex:row];

    NSNumber *userActionSubjectId;
    NSNumber *userActionExperienceId;
    NSNumber *userActionTaskId;
    
    if ([clickedItem objectForKey:@"subject"]) {
        NSDictionary *infoDic = [clickedItem objectForKey:@"subject"];
        userActionSubjectId = [infoDic objectForKey:@"subjectID"];
    }else if ([clickedItem objectForKey:@"task"]){
        NSDictionary *infoDic = [clickedItem objectForKey:@"task"];
        userActionTaskId = [infoDic objectForKey:@"taskID"];
    }else if ([clickedItem objectForKey:@"experience"]){
        NSDictionary *infoDic = [clickedItem objectForKey:@"experience"];
        userActionExperienceId = [infoDic objectForKey:@"experienceID"];
    }
    
    NSString *optionResultType;
    if (tag == TAG_CELL_ACTION_BUTTON_CAN) {
        optionResultType = OPTION_RESULT_TYPE_Y;
    }else if (tag == TAG_CELL_ACTION_BUTTON_CANT){
        optionResultType = OPTION_RESULT_TYPE_N;
    }else if (tag == TAG_CELL_ACTION_BUTTON_CANTSURE){
        optionResultType = OPTION_RESULT_TYPE_O;
    }
    
    NSNumber *userActionID = [self.actionInfoDic objectForKey:@"userActionID"];
    
    [self.viewModel submitActionByUserActionID:userActionID andOptionResultType:optionResultType andUserActionExperienceID:userActionExperienceId andUserActionTaskID:userActionTaskId andUserActionSubjectID:userActionSubjectId andCallback:^(NSDictionary *resultDic) {
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSString *result = [resultDic objectForKey:RESULT_KEY_DATA];
            if ([result isEqualToString:@"success"]) {
                //处理成功
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self deleteActionCardFromTable:indexPath];
                });
            }
        }
    }];
}

#pragma mark 删除行动项列表中的卡片
- (void)deleteActionCardFromTable:(NSIndexPath *) indexPath {
    
    [self.actionTableItems removeObjectAtIndex:indexPath.row];
    NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
    
    [CATransaction begin];
    [self.actionTable beginUpdates];
    
    [CATransaction setCompletionBlock: ^{
        // 回调
        [self.actionTable reloadData];
        [self resetActionTableHeight];
    }];
    
    [self.actionTable deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationTop];
    [self.actionTable endUpdates];
    [CATransaction commit];
    
//    [self performSelector:@selector(afterDeleteTableRow) withObject:nil afterDelay:1.0];
}

- (void)afterDeleteTableRow{
//    [self resetActionTableHeight];
    [self.actionTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark 科学小实验卡片跳转到WEB页面
- (void)jumpToDetailPage:(ActionCellButton*) button{
    NSDictionary *infoDic = button.infoDic;
    //IdentifyExperienceDetailViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExperienceDetailViewController *experienceDetailViewController = [storyboard instantiateViewControllerWithIdentifier:IdentifyExperienceDetailViewController];
    experienceDetailViewController.dataDic = infoDic;
    
    [self.navigationController pushViewController:experienceDetailViewController animated:YES];
}

#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger tableCount = self.actionTableItems.count;
    NSLog(@"tableCount : %lu",(unsigned long)tableCount);
    return tableCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *item = [self.actionTableItems objectAtIndex:indexPath.row];
    
    if ([item objectForKey:@"subject"]) {
        
        static NSString *subjectCellId = @"subjectCellId";
        //定义标志，保证仅为该表格注册一次单元格视图
        static BOOL subjectCellisRegist = NO;
        
        if (!subjectCellisRegist) {
            UINib *nib = [UINib nibWithNibName:@"ActionCell" bundle:nil];
            //注册单元格
            [self.actionTable registerNib:nib forCellReuseIdentifier:subjectCellId];
            subjectCellisRegist = YES;
        }
        
        ActionCell *tableCell = [tableView dequeueReusableCellWithIdentifier:subjectCellId];
        
        //subject
        NSDictionary *infoDic = [item objectForKey:@"subject"];
        NSString *subjectName = [infoDic objectForKey:@"subjectName"];
        tableCell.brif.text = subjectName;
        
        tableCell.btnCan.rowIndex = indexPath.row;
        tableCell.btnCant.rowIndex = indexPath.row;
        tableCell.btnNotSure.rowIndex = indexPath.row;
        
        tableCell.btnCan.indexPath = indexPath;
        tableCell.btnCant.indexPath = indexPath;
        tableCell.btnNotSure.indexPath = indexPath;
        
        [tableCell.btnCan addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tableCell.btnCant addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tableCell.btnNotSure addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return tableCell;
        
    }
    
    if ([item objectForKey:@"task"]){
        
        static NSString *taskCellId = @"taskCellId";
        static BOOL taskCellisRegist = NO;
        
        if (!taskCellisRegist) {
            UINib *nib = [UINib nibWithNibName:@"ActionCell" bundle:nil];
            //注册单元格
            [self.actionTable registerNib:nib forCellReuseIdentifier:taskCellId];
            taskCellisRegist = YES;
        }
        
        ActionCell *tableCell = [tableView dequeueReusableCellWithIdentifier:taskCellId];
        
        //task
        NSDictionary *infoDic = [item objectForKey:@"task"];
        NSString *taskName = [infoDic objectForKey:@"taskName"];
        tableCell.brif.text = taskName;
        tableCell.cardTitle.text = @"今日之任务";
        tableCell.cartTitleImage.image = [UIImage imageNamed:@"card_task"];
        
        tableCell.btnCan.rowIndex = indexPath.row;
        tableCell.btnCant.rowIndex = indexPath.row;
        tableCell.btnNotSure.rowIndex = indexPath.row;
        
        tableCell.btnCan.indexPath = indexPath;
        tableCell.btnCant.indexPath = indexPath;
        tableCell.btnNotSure.indexPath = indexPath;
        
        [tableCell.btnCan addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tableCell.btnCant addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tableCell.btnNotSure addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return tableCell;
        
    }
    
    if ([item objectForKey:@"experience"]){
        static NSString *expCellId = @"expCellId";
        //体验-科学实验
        static NSString *sciCellId = @"sciCellId";
        
        //定义标志，保证仅为该表格注册一次单元格视图
        static BOOL expCellisRegist = NO;
        if (!expCellisRegist) {
            UINib *nib = [UINib nibWithNibName:@"ActionExpCell" bundle:nil];
            //注册单元格
            [self.actionTable registerNib:nib forCellReuseIdentifier:expCellId];
            
            UINib *sci_nib = [UINib nibWithNibName:@"ActionSciCell" bundle:nil];
            [self.actionTable registerNib:sci_nib forCellReuseIdentifier:sciCellId];
            
            expCellisRegist = YES;
        }
        
        //experience
        NSDictionary *infoDic = [item objectForKey:@"experience"];
        
        //判断体验类型
        NSString *experienceTypeKey = [infoDic objectForKey:@"experienceTypeKey"];
        if ([experienceTypeKey isEqualToString:EXPERIENCE_SCIENCE]) {
            //科学小实验
            ActionSciCell *tableCell = [tableView dequeueReusableCellWithIdentifier:sciCellId];
            //标题
            NSString *experienceName = [infoDic objectForKey:@"experienceName"];
            tableCell.cardTitle.text = experienceName;
            //内容
            NSString *experienceBrief = [infoDic objectForKey:@"experienceBrief"];
            tableCell.cardContent.text = experienceBrief;
            //添加跳转按钮
            [tableCell.btnDetail addTarget:self action:@selector(jumpToDetailPage:) forControlEvents:UIControlEventTouchUpInside];
            //URL
            tableCell.btnDetail.infoDic = infoDic;
            //选择按钮
            tableCell.btnCan.rowIndex = indexPath.row;
            tableCell.btnCant.rowIndex = indexPath.row;
            tableCell.btnNotSure.rowIndex = indexPath.row;
            
            tableCell.btnCan.indexPath = indexPath;
            tableCell.btnCant.indexPath = indexPath;
            tableCell.btnNotSure.indexPath = indexPath;
            
            [tableCell.btnCan addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [tableCell.btnCant addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [tableCell.btnNotSure addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            return tableCell;
        }else{
            if ([experienceTypeKey isEqualToString:EXPERIENCE_STORY]){
                //互动故事
                ActionExpCell *tableCell = [tableView dequeueReusableCellWithIdentifier:expCellId];
                NSString *experienceName = [infoDic objectForKey:@"experienceName"];
                
                tableCell.titleLabel.text = @"互动故事";
                
                tableCell.contentLabel.text = experienceName;
                
                //选择按钮
                tableCell.btnFinish.rowIndex = indexPath.row;
                tableCell.btnAbandon.rowIndex = indexPath.row;
                tableCell.btnOtherTime.rowIndex = indexPath.row;
                
                tableCell.btnFinish.indexPath = indexPath;
                tableCell.btnAbandon.indexPath = indexPath;
                tableCell.btnOtherTime.indexPath = indexPath;
                
                [tableCell.btnFinish addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [tableCell.btnAbandon addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [tableCell.btnOtherTime addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                //播放按钮
                tableCell.actionButton.isPlaying = NO;
                tableCell.actionButton.rowIndex = indexPath.row;
                tableCell.actionButton.indexPath = indexPath;
                [tableCell.actionButton addTarget:self action:@selector(cellActionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.allActionButtons addObject:tableCell.actionButton];
                
                return tableCell;
            }else
            if ([experienceTypeKey isEqualToString:EXPERIENCE_SONG]) {
                //互动儿歌
                ActionExpCell *tableCell = [tableView dequeueReusableCellWithIdentifier:expCellId];
                tableCell.titleLabel.text = @"互动儿歌";
                NSString *experienceName = [infoDic objectForKey:@"experienceName"];
                
                tableCell.contentLabel.text = experienceName;
                
                //选择按钮
                tableCell.btnFinish.rowIndex = indexPath.row;
                tableCell.btnAbandon.rowIndex = indexPath.row;
                tableCell.btnOtherTime.rowIndex = indexPath.row;
                
                tableCell.btnFinish.indexPath = indexPath;
                tableCell.btnAbandon.indexPath = indexPath;
                tableCell.btnOtherTime.indexPath = indexPath;
                
                [tableCell.btnFinish addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [tableCell.btnAbandon addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [tableCell.btnOtherTime addTarget:self action:@selector(cellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                //播放按钮
                tableCell.actionButton.isPlaying = NO;
                tableCell.actionButton.rowIndex = indexPath.row;
                tableCell.actionButton.indexPath = indexPath;
                [tableCell.actionButton addTarget:self action:@selector(cellActionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.allActionButtons addObject:tableCell.actionButton];
                
                return tableCell;
            }
        }
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.actionTableItems objectAtIndex:indexPath.row];
    if ([item objectForKey:@"subject"]) {
        return Height_Action_Subject_Cell;
    }
    
    if ([item objectForKey:@"task"]){
        return Height_Action_Subject_Cell;
    }
    
    if ([item objectForKey:@"experience"]){
        //判断体验类型
        NSString *experienceTypeKey = [[item objectForKey:@"experience"] objectForKey:@"experienceTypeKey"];
        if ([experienceTypeKey isEqualToString:EXPERIENCE_SCIENCE]) {
            return Height_Action_exp_sci_cell;
        }else{
            return Height_Action_exp_Cell;
        }
    }
    
    return Height_Action_Subject_Cell;
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
