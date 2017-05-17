//
//  ExperienceListViewController.m
//  Growup
//
//  Created by Jerry on 2017/5/12.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "ExperienceListViewController.h"
#import "globalHeader.h"
#import "ExperienceViewModel.h"
#import "UserInfoModel.h"
#import "KidInfoModel.h"
#import "JerryTools.h"
#import "JerryViewTools.h"
#import "ExperienceCell.h"
#import "ExperienceDetailViewController.h"
#import "MJRefresh.h"

@interface ExperienceListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *experienceListTable;

@property (strong,nonatomic) ExperienceViewModel *viewModel;

@property (strong,nonatomic) NSMutableArray *experienceTableArray;

@property (strong,nonatomic) NSNumber *pageIndex;
@property (strong,nonatomic) NSNumber *pageSize;
@property (strong,nonatomic) NSNumber *totalCount;

@property (strong,nonatomic) NSString *ageTypeKey;
@property (strong,nonatomic) NSString *experienceTypeKey;

@property (nonatomic) BOOL isLoaded;

@end

@implementation ExperienceListViewController

@synthesize tagNumber;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.experienceTableArray = [[NSMutableArray alloc] init];
    
    self.experienceListTable.delegate = self;
    self.experienceListTable.dataSource = self;
    
    self.isLoaded = NO;
    
    UserInfoModel *userInfoMode = [JerryTools getUserInfoModel];
    KidInfoModel *child = [[userInfoMode childArray] objectAtIndex:userInfoMode.currentSelectedChild];
    
    self.experienceListTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    self.viewModel = [[ExperienceViewModel alloc] init];
    
    switch ([tagNumber integerValue]) {
        case icon_game:
            self.experienceTypeKey = EXPERIENCE_GAME;
            self.title = @"互动游戏";
            break;
        case icon_science:
            self.experienceTypeKey = EXPERIENCE_SCIENCE;
            self.title = @"科学实验";
            break;
        case icon_gameguide:
            self.experienceTypeKey = EXPERIENCE_GAMEGUAID;
            self.title = @"游戏攻略";
            break;
        case icon_song:
            self.experienceTypeKey = EXPERIENCE_SONG;
            self.title = @"互动儿歌";
            break;
        case icon_story:
            self.experienceTypeKey = EXPERIENCE_STORY;
            self.title = @"互动故事";
            break;
        case icon_school:
            self.experienceTypeKey = EXPERIENCE_SCHOOL;
            self.title = @"互动面试";
            break;
    }
    
    //test
//    self.ageTypeKey = EXPERIENCE_ALL;
    self.ageTypeKey = child.ageTypeKey;
    NSLog(@"self.ageTypeKey = %@",self.ageTypeKey);
    
    [self.viewModel getExperiencesListByAgeType:self.ageTypeKey andExperienceType:self.experienceTypeKey andPageIndex:[NSNumber numberWithInt:1] andPageSize:[NSNumber numberWithInt:10] andCallback:^(NSDictionary *resultDic) {
        
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
            //page info
            NSDictionary *page = [result objectForKey:@"page"];
            self.pageIndex = [page objectForKey:@"pageIndex"];
            self.pageSize = [page objectForKey:@"pageSize"];
            self.totalCount = [page objectForKey:@"totalCount"];
            
            //solute the experience info array
            NSArray *experiences = [result objectForKey:@"experiences"];
            [self.experienceTableArray addObjectsFromArray:experiences];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.experienceListTable reloadData];
            });
        }
        
    }];
}

- (void)loadMore{
    
    NSNumber *currentPageIndex =  [NSNumber numberWithInt:[self.pageIndex intValue] + 1];
    
    [self.viewModel getExperiencesListByAgeType:self.ageTypeKey andExperienceType:self.experienceTypeKey andPageIndex:currentPageIndex andPageSize:[NSNumber numberWithInt:10] andCallback:^(NSDictionary *resultDic) {
        
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
            //page info
            NSDictionary *page = [result objectForKey:@"page"];
            self.pageIndex = [page objectForKey:@"pageIndex"];
            self.pageSize = [page objectForKey:@"pageSize"];
            self.totalCount = [page objectForKey:@"totalCount"];
            
            //solute the experience info array
            NSArray *experiences = [result objectForKey:@"experiences"];
            [self.experienceTableArray addObjectsFromArray:experiences];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self.experienceListTable.mj_footer endRefreshing];
                [self.experienceListTable reloadData];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    //定义标志，保证仅为该表格注册一次单元格视图
    
    if (!self.isLoaded) {
        UINib *nib = [UINib nibWithNibName:@"ExperienceCell" bundle:nil];
        //注册单元格
        [self.experienceListTable registerNib:nib forCellReuseIdentifier:cellId];
        
        self.isLoaded = YES;
    }
    
    ExperienceCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NSDictionary *dataDic = [self.experienceTableArray objectAtIndex:indexPath.row];
    NSString *experienceName = [dataDic objectForKey:@"experienceName"];
    NSString *experienceBrief = [dataDic objectForKey:@"experienceBrief"];
    NSString *logoResourceUrl = [dataDic objectForKey:@"logoResourceUrl"];
    
    tableCell.title.text = experienceName;
    tableCell.subTitle.text = experienceBrief;
    
    if ([JerryTools stringIsNull:logoResourceUrl]) {
        //默认图片
        tableCell.logoImageView.image = [UIImage imageNamed:@"game1"];
    }else{
        NSURL *url = [NSURL URLWithString:logoResourceUrl];
        tableCell.logoImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    
    return tableCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.experienceTableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic = [self.experienceTableArray objectAtIndex:indexPath.row];
    //IdentifyExperienceDetailViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExperienceDetailViewController *experienceDetailViewController = [storyboard instantiateViewControllerWithIdentifier:IdentifyExperienceDetailViewController];
    experienceDetailViewController.dataDic = dataDic;
    
    [self.navigationController pushViewController:experienceDetailViewController animated:YES];
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
