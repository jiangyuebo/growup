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


@end

@implementation MainPageViewController

bool isClick = true;

bool isBubbleShowed = false;


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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBar];
}

- (void)initView{
    
    self.title = @"首页";
    
    //设置VIEW圆角
    UIView *targetView = [self.view viewWithTag:1];
    [self setViewRoundCorner:targetView];
    
    //为笑脸图标添加点击事件
    [self setFaceInteractionEnable];
    
    //为橙宝添加点击事件
    [self setOrangeBabyInteractionEnable];
    //隐藏气泡
    [self hideBubble];
    
}

- (void)hideNavigationBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initData{
    //初始化 数据模型
    self.viewModel = [[MainPageViewModel alloc] init];
    
    //绑定VIEW与MODEL
    [self modelBinding];
    
    //获取数据
    [self.viewModel updateData];
    
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
            [JerryViewTools jumpFrom:self ToViewController:IdentifyAbilityExplainViewController];
            break;
            
        case face_society:
            NSLog(@"社会");
            [JerryViewTools jumpFrom:self ToViewController:IdentifySocietyExplainViewController];
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
        //5秒后消失
        [self performSelector:@selector(hideBubble) withObject:nil afterDelay:3.0];
        
    }
}

//气泡出现
- (void)showBubble{
    self.bubbleBackground.hidden = NO;
    self.bubbleLabel.hidden = NO;
    isBubbleShowed = true;
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

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
