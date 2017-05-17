//
//  CZNewsViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/21.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZNewsViewController.h"
#import "DiscoverViewModel.h"
#import "globalHeader.h"
#import "JerryViewTools.h"
#import "UserInfoModel.h"
#import "KidInfoModel.h"
#import "JerryTools.h"
#import "InfoModelCell.h"
#import "MJRefresh.h"

@interface CZNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *newsTable;

@property (strong,nonatomic) NSMutableArray *newsArray;

//翻页信息
@property (strong,nonatomic) NSNumber *pageIndex;
@property (strong,nonatomic) NSNumber *pageSize;
@property (strong,nonatomic) NSNumber *totalCount;

@property (strong,nonatomic) NSString *ageType;

@property (nonatomic) BOOL isLoad;

@property (strong,nonatomic) DiscoverViewModel *viewModel;

@end

@implementation CZNewsViewController

@synthesize infoTypeKey,infoDetailTypeKey;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isLoad = NO;
    
    if ([infoTypeKey isEqualToString:INFO_ARTICLE]) {
        self.title = @"养育百科";
    }else if ([infoTypeKey isEqualToString:INFO_BABY]){
        self.title = @"惊喜宝贝";
    }
    
    self.newsTable.delegate = self;
    self.newsTable.dataSource = self;
    
    self.newsTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreInfo)];
    
    self.newsArray = [[NSMutableArray alloc] init];
    self.pageIndex = [NSNumber numberWithInt:1];
    
    [self initData];
}

- (void)loadMoreInfo{
    
    NSNumber *currentIndex = [NSNumber numberWithInt:[self.pageIndex intValue] + 1];
    
    [self.viewModel getDiscoverInfoByAgeType:self.ageType andInfoTypeKey:self.infoTypeKey andInfoDetailTypeKey:self.infoDetailTypeKey andPageIndex:currentIndex andPageSize:[NSNumber numberWithInt:10] andCallback:^(NSDictionary *resultDic) {
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
            //页面信息
            NSDictionary *page = [result objectForKey:@"page"];
            NSNumber *pageIndex = [page objectForKey:@"pageIndex"];
            self.pageIndex = pageIndex;
            NSNumber *pageSize = [page objectForKey:@"pageSize"];
            self.pageSize = pageSize;
            NSNumber *totalCount = [page objectForKey:@"totalCount"];
            self.totalCount = totalCount;
            
            //信息数组
            NSMutableArray *infoArray = [result objectForKey:@"infos"];
            
            if ([infoArray count] > 0) {
                [self.newsArray addObjectsFromArray:infoArray];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self.newsTable.mj_footer endRefreshing];
                [self.newsTable reloadData];
            });
        }
    }];
}

- (void)initData{
    
    UserInfoModel *userInfoModel = [JerryTools getUserInfoModel];
    NSArray *childArray = [userInfoModel childArray];
    KidInfoModel *childInfoModel = [childArray objectAtIndex:userInfoModel.currentSelectedChild];
    
    self.ageType = [childInfoModel ageTypeKey];
    
    self.viewModel = [[DiscoverViewModel alloc] init];
    [self.viewModel getDiscoverInfoByAgeType:self.ageType andInfoTypeKey:self.infoTypeKey andInfoDetailTypeKey:self.infoDetailTypeKey andPageIndex:[NSNumber numberWithInt:1] andPageSize:[NSNumber numberWithInt:10] andCallback:^(NSDictionary *resultDic) {
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
            //页面信息
            NSDictionary *page = [result objectForKey:@"page"];
            NSNumber *pageIndex = [page objectForKey:@"pageIndex"];
            self.pageIndex = pageIndex;
            NSNumber *pageSize = [page objectForKey:@"pageSize"];
            self.pageSize = pageSize;
            NSNumber *totalCount = [page objectForKey:@"totalCount"];
            self.totalCount = totalCount;
            
            //信息数组
            self.newsArray = [result objectForKey:@"infos"];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.newsTable reloadData];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *infoCellId = @"infoCellId";
    //定义标志，保证仅为该表格注册一次单元格视图
    if (!self.isLoad) {
        UINib *nib = [UINib nibWithNibName:@"InfoModelCell" bundle:nil];
        //注册单元格
        [self.newsTable registerNib:nib forCellReuseIdentifier:infoCellId];
        
        self.isLoad = YES;
    }
    
    InfoModelCell *infoCell = [tableView dequeueReusableCellWithIdentifier:infoCellId];
    
    NSDictionary *infoDic = [self.newsArray objectAtIndex:indexPath.row];
    NSString *infoDescription = [infoDic objectForKey:@"infoDescription"];
    NSString *infoName = [infoDic objectForKey:@"infoDescription"];
    NSString *logoResourceUrl = [infoDic objectForKey:@"logoResourceUrl"];
    
    infoCell.title.text = infoName;
    infoCell.subTitle.text = infoDescription;
    if ([JerryTools stringIsNull:logoResourceUrl]) {
        //url为空，默认图
        infoCell.image.image = [UIImage imageNamed:@"game1"];
    }else{
        NSLog(@"url : %@",logoResourceUrl);
    }
    
    return infoCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = [self.newsArray objectAtIndex:indexPath.row];
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
