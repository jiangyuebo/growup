//
//  DiscoverMainViewController.m
//  Growup
//
//  Created by Jerry on 2017/5/12.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "DiscoverMainViewController.h"
#import "GrowupRecordViewModel.h"
#import "JerryViewTools.h"
#import "JerryTools.h"
#import "globalHeader.h"
#import "DiscoverRecordCell.h"
#import "CZNewsViewController.h"

@interface DiscoverMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *recordListArray;

@property (strong,nonatomic) GrowupRecordViewModel *viewMode;

//pageInfo
@property (strong,nonatomic) NSNumber *pageIndex;
@property (strong,nonatomic) NSNumber *pageSize;
@property (strong,nonatomic) NSNumber *totalCount;

@property (nonatomic) BOOL isLoaded;

@end

@implementation DiscoverMainViewController

- (IBAction)toFeed:(UIButton *)sender {
    //IdentifyNameDiscoverInfoListViewController
    CZNewsViewController *viewController = [JerryViewTools getViewControllerById:IdentifyNameDiscoverInfoListViewController];
    viewController.infoTypeKey = INFO_ARTICLE;
    viewController.infoDetailTypeKey = INFO_DETAIL_TYPE_ALL;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)toBaby:(UIButton *)sender {
    CZNewsViewController *viewController = [JerryViewTools getViewControllerById:IdentifyNameDiscoverInfoListViewController];
    viewController.infoTypeKey = INFO_BABY;
    viewController.infoDetailTypeKey = INFO_DETAIL_TYPE_ALL;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isLoaded = NO;
    
    self.publicRecordTable.delegate = self;
    self.publicRecordTable.dataSource = self;
    
    self.recordListArray = [[NSMutableArray alloc] init];
    self.viewMode = [[GrowupRecordViewModel alloc] init];
    
    [self.viewMode getGrowupRecordByRecordType:nil andPublicType:nil andIsInfo:nil andCallback:^(NSDictionary *resultDic) {
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
            NSDictionary *page = [result objectForKey:@"page"];
            NSNumber *pageIndex = [page objectForKey:@"pageIndex"];
            self.pageIndex = pageIndex;
            NSNumber *pageSize = [page objectForKey:@"pageSize"];
            self.pageSize = pageSize;
            NSNumber *totalCount = [page objectForKey:@"totalCount"];
            self.totalCount = totalCount;
            
            self.recordListArray = [result objectForKey:@"records"];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //添加header
                UIView *tableHeader = [JerryViewTools getViewByXibName:@"DiscoverTableHeader"];
                self.publicRecordTable.tableHeaderView = tableHeader;
                
                [self.publicRecordTable reloadData];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *discoverRecordCellId = @"discoverRecordCellId";
    
    if (!self.isLoaded) {
        UINib *nib = [UINib nibWithNibName:@"DiscoverRecordCell" bundle:nil];
        //注册单元格
        [self.publicRecordTable registerNib:nib forCellReuseIdentifier:discoverRecordCellId];
        self.isLoaded = YES;
    }
    
    DiscoverRecordCell *tableCell = [tableView dequeueReusableCellWithIdentifier:discoverRecordCellId];
    
    NSDictionary *dataDic = [self.recordListArray objectAtIndex:indexPath.row];
    
    tableCell.content.text = [dataDic objectForKey:@"recordContent"];
    
    //avatar
    tableCell.avatar.image = [UIImage imageNamed:@"avatar_discover"];
    //publishDate
    NSNumber *publishDate = [dataDic objectForKey:@"publishDate"];
    long long publishTimestamp = [publishDate longLongValue];
    long long currentTimestamp = [JerryTools getCurrentTimestamp];
    long long milliseconds = currentTimestamp - publishTimestamp;
    int hour = (int)milliseconds/3600000;
    
    NSString *hourStr;
    if (hour < 1) {
        hourStr = [NSString stringWithFormat:@"刚刚"];
    }else if (hour < 24) {
        hourStr = [NSString stringWithFormat:@"%d 小时前",hour];
    }else{
        int day = hour/24;
        hourStr = [NSString stringWithFormat:@"%d 天前",day];
    }
    
    tableCell.timeLabel.text = hourStr;
    
    NSNumber *userId = [dataDic objectForKey:@"userID"];
    //用户名
    NSString *userName = [NSString stringWithFormat:@"用户%@",userId];
    tableCell.userName.text = userName;
    
    NSLog(@"hello");
    
    return tableCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
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
