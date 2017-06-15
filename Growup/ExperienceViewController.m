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
#import "ExperienceCell.h"
#import "ExperienceModel.h"
#import "ExperienceListViewController.h"

@interface ExperienceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *companyTime;

@property (strong, nonatomic) IBOutlet UILabel *companyRante;

@property (strong,nonatomic) ExperienceViewModel *viewModel;

//互动游戏table
@property (strong, nonatomic) IBOutlet UITableView *gameTable;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *gameTableHeight;

@property (strong,nonatomic) NSArray *gameTableArray;

//科学实验table
@property (strong, nonatomic) IBOutlet UITableView *science;

@property (strong,nonatomic) NSArray *scienceTalbeArray;

//互动故事
@property (strong, nonatomic) IBOutlet UITableView *storyTable;

//分类按钮
@property (strong, nonatomic) IBOutlet UIImageView *scienceBtn;

@property (strong, nonatomic) IBOutlet UIImageView *songBtn;

@property (strong, nonatomic) IBOutlet UIImageView *storyBtn;

@property (strong, nonatomic) IBOutlet UIImageView *schoolBtn;

@end

@implementation ExperienceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //显示陪伴时间和陪伴等级
    UserInfoModel *userInfoMode = [JerryTools getUserInfoModel];
    if (userInfoMode) {
        NSArray *childArray = [userInfoMode childArray];
        if (childArray) {
            if ([childArray count] > 0) {
                KidInfoModel *child = [[userInfoMode childArray] objectAtIndex:userInfoMode.currentSelectedChild];
                if (child) {
                    //陪伴时间显示
                    NSString *companyTimeValue = [child accompanyTimeValue];
                    self.companyTime.text = companyTimeValue;
                    
                    //陪伴等级
                    NSNumber *companyRate = [child accompanyRate];
                    self.companyRante.text = [NSString stringWithFormat:@"打败了全国%@%%的家长哦~",companyRate];
                }
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initView];
}

- (void)initView{
    //初始分类点击
    NSMutableArray *iconArray = [[NSMutableArray alloc] init];
    
    [iconArray addObject:self.scienceBtn];
    [iconArray addObject:self.songBtn];
    [iconArray addObject:self.storyBtn];
    [iconArray addObject:self.schoolBtn];
    
    for (int i = 0; i < [iconArray count]; i++) {
        UITapGestureRecognizer *gestureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClicked:)];
        UIImageView *imageIcon = [iconArray objectAtIndex:i];
        imageIcon.userInteractionEnabled = YES;
        imageIcon.tag = 20 + i;
        [imageIcon addGestureRecognizer:gestureTap];
    }
    
    self.gameTable.scrollEnabled = NO;
    
    self.science.scrollEnabled = NO;
    
    self.storyTable.scrollEnabled = NO;
    
    [self initTableViewHeader];
}

- (void)iconClicked:(UITapGestureRecognizer *) recognizer{
    
    NSNumber *tagNumber = [NSNumber numberWithLong:recognizer.view.tag];
    NSLog(@"tagNumber : %@",tagNumber);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExperienceListViewController *experienceListViewController = [storyboard instantiateViewControllerWithIdentifier:IdentifyExperienceListViewController];
    experienceListViewController.tagNumber = tagNumber;
    
    [self.navigationController pushViewController:experienceListViewController animated:YES];
}

- (void)initTableViewHeader{
    //获取游戏列表头view
    UIView *tableHeader_game = [JerryViewTools getViewByXibName:@"ExperienceTableHeader"];
    self.gameTable.tableHeaderView = tableHeader_game;
    
    UIView *tableHeader_science = [JerryViewTools getViewByXibName:@"ExperienceTableHeader"];
    UILabel *title_science = [tableHeader_science viewWithTag:1];
    title_science.text = @"科学小实验";
    self.science.tableHeaderView = tableHeader_science;
    
    UIView *tableHeader_story = [JerryViewTools getViewByXibName:@"ExperienceTableHeader"];
    UILabel *title_story = [tableHeader_story viewWithTag:1];
    title_story.text = @"互动故事";
    self.storyTable.tableHeaderView = tableHeader_story;
}

- (void)initData{
    self.viewModel = [[ExperienceViewModel alloc] init];
    
    //初始化表格
    self.gameTable.delegate = self;
    self.gameTable.dataSource = self;
    
    self.science.delegate = self;
    self.science.dataSource = self;
    
    self.storyTable.delegate = self;
    self.storyTable.dataSource = self;
    
    //获取体验体验内容列表
//    [self getExperienceList];
}

- (void)getExperienceList{
    UserInfoModel *userInfoMode = [JerryTools getUserInfoModel];
    KidInfoModel *child;
    if (userInfoMode) {
        child = [[userInfoMode childArray] objectAtIndex:userInfoMode.currentSelectedChild];
    }
    
    if (child) {
        //获取互动游戏
        [self.viewModel getExperiencesListByAgeType:[child ageTypeKey] andExperienceType:EXPERIENCE_GAME andPageIndex:[NSNumber numberWithInt:1] andPageSize:[NSNumber numberWithInt:4] andCallback:^(NSDictionary *resultDic) {
            
            NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
            if (errorMessage) {
                //error
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [JerryViewTools showCZToastInViewController:self andText:errorMessage];
                });
            }else{
                NSArray *experienceArray = [resultDic objectForKey:RESULT_KEY_DATA];
                
                if ([experienceArray count] > 0) {
                    self.gameTableArray = experienceArray;
                    
                    [self.gameTable reloadData];
                }
            }
        }];
        
        //获取科学小实验
        [self.viewModel getExperiencesListByAgeType:[child ageTypeKey] andExperienceType:EXPERIENCE_SCIENCE andPageIndex:[NSNumber numberWithInt:1] andPageSize:[NSNumber numberWithInt:4] andCallback:^(NSDictionary *resultDic) {
            
            NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
            if (errorMessage) {
                //error
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [JerryViewTools showCZToastInViewController:self andText:errorMessage];
                });
            }else{
                NSArray *scienceArray = [resultDic objectForKey:RESULT_KEY_DATA];
                if ([scienceArray count] > 0) {
                    self.scienceTalbeArray = scienceArray;
                    [self.science reloadData];
                }
            }
            
        }];
        
        //获取互动故事
        [self.viewModel getExperiencesListByAgeType:[child ageTypeKey] andExperienceType:EXPERIENCE_STORY andPageIndex:[NSNumber numberWithInt:1] andPageSize:[NSNumber numberWithInt:4] andCallback:^(NSDictionary *resultDic) {
            
            NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
            if (errorMessage) {
                //error
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [JerryViewTools showCZToastInViewController:self andText:errorMessage];
                });
            }else{
                NSArray *scienceArray = [resultDic objectForKey:RESULT_KEY_DATA];
                if ([scienceArray count] > 0) {
                    NSLog(@"scienceArray count > 0");
                }else{
                    NSLog(@"scienceArray is empty");
                }
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

#pragma mark table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.gameTableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    //定义标志，保证仅为该表格注册一次单元格视图
    static BOOL isExperienceCellRegist = NO;
    if (!isExperienceCellRegist) {
        UINib *nib = [UINib nibWithNibName:@"ExperienceCell" bundle:nil];
        //注册单元格
        [self.gameTable registerNib:nib forCellReuseIdentifier:cellId];
        [self.science registerNib:nib forCellReuseIdentifier:cellId];
        [self.storyTable registerNib:nib forCellReuseIdentifier:cellId];
        
        isExperienceCellRegist = YES;
    }
    
    ExperienceCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (tableView == self.gameTable) {
        NSLog(@"游戏列表");
        id item = [self.gameTableArray objectAtIndex:indexPath.row];
        ExperienceModel *subject = item;
        //标题
        NSString *experienceName = [subject experienceName];
        if ([JerryTools stringIsNull:experienceName]) {
            experienceName = @"无数据";
        }
        tableCell.title.text = experienceName;
        
        //subtitle
        
        //图片
        NSString *logoResourceUrl = [subject logoResourceUrl];
        if ([JerryTools stringIsNull:logoResourceUrl]) {
            //默认图片
            tableCell.logoImageView.image = [UIImage imageNamed:@"game1"];
        }else{
            NSLog(@"url not nil");
        }
    }
    
    if (tableView == self.science) {
        NSLog(@"科学小游戏");
        id item = [self.scienceTalbeArray objectAtIndex:indexPath.row];
        
        ExperienceModel *subject = item;
        //标题
        NSString *experienceName = [subject experienceName];
        if ([JerryTools stringIsNull:experienceName]) {
            experienceName = @"无数据";
        }
        tableCell.title.text = experienceName;
        
        //subtitle
        
        //图片
        NSString *logoResourceUrl = [subject logoResourceUrl];
        if ([JerryTools stringIsNull:logoResourceUrl]) {
            //默认图片
            tableCell.logoImageView.image = [UIImage imageNamed:@"game1"];
        }else{
            NSLog(@"url not nil");
        }
    }
    
    if (tableView == self.storyTable) {
        NSLog(@"互动故事");
        
    }
    
    return tableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
