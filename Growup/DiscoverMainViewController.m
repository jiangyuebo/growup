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
#import "PicDetailViewController.h"
#import "MJRefresh.h"

@interface DiscoverMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *recordListArray;

@property (strong,nonatomic) GrowupRecordViewModel *viewMode;

//pageInfo
@property (strong,nonatomic) NSNumber *pageIndex;
@property (strong,nonatomic) NSNumber *pageSize;
@property (strong,nonatomic) NSNumber *totalCount;

@property (nonatomic) int pageIndexInt;

@property (strong,nonatomic) NSMutableDictionary *publicRecordPicCache;

@property (nonatomic) BOOL isLoaded;

@end

@implementation DiscoverMainViewController

- (void)toFeed{
    //IdentifyNameDiscoverInfoListViewController
    CZNewsViewController *viewController = [JerryViewTools getViewControllerById:IdentifyNameDiscoverInfoListViewController];
    viewController.infoTypeKey = INFO_ARTICLE;
    viewController.infoDetailTypeKey = INFO_DETAIL_TYPE_ALL;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)toBaby{
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
    
    self.pageIndex = [NSNumber numberWithInt:1];
    
    self.recordListArray = [[NSMutableArray alloc] init];
    self.viewMode = [[GrowupRecordViewModel alloc] init];
    
    self.publicRecordPicCache = [NSMutableDictionary dictionary];
    
    self.pageIndexInt = 1;
    
    self.publicRecordTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDiscoverRecord)];
    
    [self loadDiscoverRecord];
}

- (void)loadDiscoverRecord{
    [self.viewMode getGrowupRecordByRecordType:GROWUP_INITIATIVE andPublicType:GROWUP_RECORD_PUBLIC_ALL andPageIndex:[NSNumber numberWithInt:self.pageIndexInt] andPageSize:[NSNumber numberWithInt:5] andIsInfo:NO andCallback:^(NSDictionary *resultDic) {
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
                [self.publicRecordTable.mj_footer endRefreshing];
            });
        }else{
            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
            if (result) {
                NSDictionary *page = [result objectForKey:@"page"];
                NSNumber *pageIndex = [page objectForKey:@"pageIndex"];
                self.pageIndex = pageIndex;
                NSNumber *pageSize = [page objectForKey:@"pageSize"];
                self.pageSize = pageSize;
                NSNumber *totalCount = [page objectForKey:@"totalCount"];
                self.totalCount = totalCount;
                
                [self.recordListArray addObjectsFromArray:[result objectForKey:@"records"]];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.publicRecordTable.mj_footer endRefreshing];
                    [self.publicRecordTable reloadData];
                });
            }
        }
    }];
}

- (void)loadMoreDiscoverRecord{
    self.pageIndexInt ++;
    [self loadDiscoverRecord];
}

#pragma mark 点击图片
- (void)cellPicClicked:(UITapGestureRecognizer *) sender{
    CellImageView *imageView = (CellImageView *)sender.view;
    
    //IdentifyNamePicDetailViewController
    PicDetailViewController *picDetailViewController = [JerryViewTools getViewControllerById:IdentifyNamePicDetailViewController];
    picDetailViewController.resourcePath = imageView.resourcePath;
    [self.navigationController pushViewController:picDetailViewController animated:YES];
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
    
    NSMutableArray *cellImageViewArray = [[NSMutableArray alloc] init];
    [cellImageViewArray addObject:tableCell.pic1];
    [cellImageViewArray addObject:tableCell.pic2];
    [cellImageViewArray addObject:tableCell.pic3];
    [cellImageViewArray addObject:tableCell.pic4];
    [cellImageViewArray addObject:tableCell.pic5];
    [cellImageViewArray addObject:tableCell.pic6];
    [cellImageViewArray addObject:tableCell.pic7];
    [cellImageViewArray addObject:tableCell.pic8];
    [cellImageViewArray addObject:tableCell.pic9];
    
    //清除CELL中缓存图片
    for (int i = 0; i < [cellImageViewArray count]; i++) {
        CellImageView *picView = cellImageViewArray[i];
        picView.image = nil;
        
        //添加点击方法
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellPicClicked:)];
        picView.userInteractionEnabled = YES;
        [picView addGestureRecognizer:singleTap];
    }
    
    //获取图片内容
    NSArray *recordDetailsArray = [dataDic objectForKey:@"recordDetails"];
    NSMutableArray *recordPicsURLArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [recordDetailsArray count]; i++) {
        NSDictionary *recordDetailDic = recordDetailsArray[i];
        NSString *picURLStr = [recordDetailDic objectForKey:@"contentResourceTypeUrl"];
        [recordPicsURLArray addObject:picURLStr];
    }
    
    if ([recordPicsURLArray count] > 0) {
//        tableCell.picUrlArray  = recordPicsURLArray;
        
        //设置图片
        for (int i = 0; i < [recordPicsURLArray count]; i++) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *picURLStr = recordPicsURLArray[i];
                
                NSString *urlImageKey = [picURLStr lastPathComponent];
                
                //查看缓存中是否存在
                UIImage *cachePic = [self.publicRecordPicCache objectForKey:urlImageKey];
                //imageView
                CellImageView *picView = cellImageViewArray[i];
                picView.resourcePath = [picURLStr copy];
                
                if (cachePic) {
                    //缓存中有
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        picView.image = cachePic;
                    });
                }else{
                    //缓存中无
                    picURLStr =  [picURLStr stringByReplacingOccurrencesOfString:@"cossh" withString:@"picsh"];
                    picURLStr = [picURLStr stringByAppendingString:SHOTCUT_TAIL];
                    //URL特殊字符转译
                    //                picURLStr = [picURLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%/<>?@\\^`{|}-"].invertedSet];
                    
                    picURLStr = [picURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSURL *imageURL = [NSURL URLWithString:picURLStr];
                    UIImage *shotCutImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        picView.image = shotCutImage;
                    });
                    
                    //放进缓存
                    if (shotCutImage) {
                        [self.publicRecordPicCache setObject:shotCutImage forKey:urlImageKey];
                    }
                    
                }
            });
        }
    }
    
    //avatar
    tableCell.avatar.image = [UIImage imageNamed:@"avatar"];
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
    //用户昵称
    NSString *nickName = [[dataDic objectForKey:@"user"] objectForKey:@"nickName"];
    if ([JerryTools stringIsNull:nickName]) {
        nickName = [NSString stringWithFormat:@"用户%@",userId];
    }else{
        if ([nickName isEqualToString:@"橙宝"]) {
            nickName = [NSString stringWithFormat:@"橙宝%@",userId];
        }
    }
    
    tableCell.userName.text = nickName;
    
    return tableCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat contentWidth = self.publicRecordTable.frame.size.width - (8 + 50 + 8);//得到textview宽度
    
    //获得文字内容
    NSDictionary *dataDic = [self.recordListArray objectAtIndex:indexPath.row];
    NSString *recordContent = [dataDic objectForKey:@"recordContent"];
    
    CGRect rect = [recordContent boundingRectWithSize:CGSizeMake( contentWidth,1000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];//根据content的文字，系统默认字体，字体大小为16来计算得到rect
    
    CGFloat height = rect.size.height + 20;
    //获取图片个数
    NSArray *recordDetailsArray = [dataDic objectForKey:@"recordDetails"];
    NSUInteger picCount = [recordDetailsArray count];
    
    CGFloat picGroupHeight = 0;
    
    NSUInteger row = picCount / 3;
    if (picCount % 3 > 0) {
        row = row + 1;
    }
    picGroupHeight = row * 100;
    
    height = height + picGroupHeight + 80;
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //设置表头
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 300)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat buttonWidth = (SCREENWIDTH - 10 - 10 - 20 ) / 2;
    CGFloat buttonHeight = (buttonWidth / 556) * 302;
    
    UIButton *btnJXBB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect btnJXBBFrame = CGRectMake(10, 10, buttonWidth, buttonHeight);
    btnJXBB.frame = btnJXBBFrame;
    [btnJXBB addTarget:self action:@selector(toBaby) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image_jxbb = [UIImage imageNamed:@"banner_jxbb"];
    UIImageView *iv_jxbb = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, buttonWidth, buttonHeight)];
    [iv_jxbb setImage:image_jxbb];
    [btnJXBB addSubview:iv_jxbb];
    
    UIButton *btnYYZX = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect btnYYBKFrame = CGRectMake(10 + buttonWidth + 20, 10, buttonWidth, buttonHeight);
    btnYYZX.frame = btnYYBKFrame;
    [btnYYZX addTarget:self action:@selector(toFeed) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image_yybk = [UIImage imageNamed:@"banner_yybk"];
    UIImageView *iv_yybk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    [iv_yybk setImage:image_yybk];
    [btnYYZX addSubview:iv_yybk];
    
    //添加文字
    UILabel *lbJxbb = [[UILabel alloc] initWithFrame:CGRectMake(10,10 + buttonHeight + 10, buttonWidth, 20)];
    [lbJxbb setText:@"惊喜宝贝"];
    lbJxbb.textAlignment = NSTextAlignmentCenter;
    lbJxbb.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:lbJxbb];
    
    UILabel *lbYybk = [[UILabel alloc] initWithFrame:CGRectMake(10 + buttonWidth + 20,10 + buttonHeight + 10, buttonWidth, 20)];
    [lbYybk setText:@"养育百科"];
    lbYybk.textAlignment = NSTextAlignmentCenter;
    lbYybk.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:lbYybk];
    
    UIView *dashView = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight + 45, SCREENWIDTH, 1)];
    dashView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //好友动态 文字
    UILabel *lbHydt = [[UILabel alloc] initWithFrame:CGRectMake(10,buttonHeight + 55, SCREENWIDTH, 20)];
    [lbHydt setText:@"好友动态"];
    lbHydt.textAlignment = NSTextAlignmentLeft;
    lbHydt.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:lbHydt];
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT * 0.28 - 1, SCREENWIDTH, 1)];
    buttomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [headerView addSubview:btnJXBB];
    [headerView addSubview:btnYYZX];
    [headerView addSubview:dashView];
    [headerView addSubview:buttomView];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREENHEIGHT * 0.28;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
