//
//  CZGrowupRecordViewController.m
//  Growup
//
//  Created by Jerry on 2017/5/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZGrowupRecordViewController.h"
#import "GrowupRecordViewModel.h"
#import "globalHeader.h"
#import "JerryViewTools.h"
#import "RecordCell.h"
#import "RecordHeaderView.h"
#import "CellImageView.h"
#import "PicDetailViewController.h"
#import "MJRefresh.h"

@interface CZGrowupRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) GrowupRecordViewModel *viewModel;

@property (strong, nonatomic) IBOutlet UITableView *recordTable;

@property (strong,nonatomic) NSMutableArray *recordsArray;

@property (strong,nonatomic) NSMutableDictionary *sortedGroupRecordDic;

@property (strong,nonatomic) NSArray *recordKeysArray;

@property (strong,nonatomic) NSMutableDictionary *recordGroupData;

@property (strong,nonatomic) NSMutableDictionary *picCache;

@property (strong,nonatomic) NSNumber *pageIndex;

@property (nonatomic) int pageIndexInt;

@end

@implementation CZGrowupRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.pageIndexInt = 1;
    [self.recordsArray removeAllObjects];
    
    [self loadSelfRecord];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initView];
}

- (void)initData{
    
    self.recordTable.delegate = self;
    self.recordTable.dataSource = self;
    
    self.pageIndex = [NSNumber numberWithInt:1];
    self.pageIndexInt = 1;
    
    self.viewModel = [[GrowupRecordViewModel alloc] init];
    
    self.recordsArray = [[NSMutableArray alloc] init];
    
    self.recordGroupData = [NSMutableDictionary dictionary];
    
    self.sortedGroupRecordDic = [NSMutableDictionary dictionary];
    
    self.picCache = [NSMutableDictionary dictionary];

}

- (void)initView{
    self.recordTable.separatorStyle = NO;
    self.recordTable.allowsSelection = NO;
    
    self.recordTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRecordInfo)];
}

- (void)loadMoreRecordInfo{
    self.pageIndexInt ++;
    
    [self loadSelfRecord];
}

#pragma mark 查看自己橙长记
- (void)loadSelfRecord{
    
    [self.viewModel getGrowupRecordByRecordType:nil andPublicType:nil andPageIndex:[NSNumber numberWithInt:self.pageIndexInt] andPageSize:[NSNumber numberWithInt:5] andIsInfo:NO andCallback:^(NSDictionary *resultDic) {
        
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
            
            NSArray *recordArray = [result objectForKey:@"records"];
            self.pageIndex = [result objectForKey:@"pageIndex"];
            
//            recordArray = [[recordArray reverseObjectEnumerator] allObjects];
            
            for (int i = 0; i < [recordArray count]; i++) {
                [self.recordsArray insertObject:recordArray[i] atIndex:0];
            }
            
//            [self.recordsArray addObjectsFromArray:recordArray];
            
            NSLog(@"recordsArray count : %ld",[self.recordsArray count]);
            
            self.sortedGroupRecordDic = [self sortOutRecordToGroupData:self.recordsArray];
            
            self.recordKeysArray = [self.sortedGroupRecordDic allKeys];
            //排序
            self.recordKeysArray = [self.recordKeysArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSComparisonResult result = [obj1 compare:obj2 options:NSNumericSearch];
                return result == NSOrderedAscending; // 降序;
            }];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.recordTable.mj_footer endRefreshing];
                
                [self.recordTable reloadData];
            });
        }
    }];
}

#pragma mark 将原纪录数据整理为列表可用的数据
- (void)sortOutRecordListData:(NSArray *) recordDataList{
    self.recordsArray = (NSMutableArray *)recordDataList;
}

#pragma mark 整理记录数据为可用分组数据
- (NSMutableDictionary *)sortOutRecordToGroupData:(NSArray *) recordArray{
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    
    NSString *cacheDateStr = @"";
    NSMutableArray *dateRecord;
    for (int i = 0; i < [recordArray count]; i++) {
        NSDictionary *dataDic = recordArray[i];
        NSNumber *publishDate = [dataDic objectForKey:@"publishDate"];
        NSDate *publishDateDate = [[NSDate alloc] initWithTimeIntervalSince1970:[publishDate longLongValue]/1000.0];
        //转化日期为字符串
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [dateFormatter stringFromDate:publishDateDate];

        if (![dateStr isEqualToString:cacheDateStr]) {
            if (dateRecord) {
                //放入
                //倒序一下
                NSArray *reverseArray = [[dateRecord reverseObjectEnumerator] allObjects];
                [resultDic setValue:reverseArray forKey:cacheDateStr];
            }
            
            //创建新的
            dateRecord = [[NSMutableArray alloc] init];
            cacheDateStr = dateStr;
        }
        //放入
        [dateRecord addObject:dataDic];
        
        //最后一组
        if (i == ([recordArray count] -1)) {
            NSArray *reverseArray = [[dateRecord reverseObjectEnumerator] allObjects];
            [resultDic setValue:reverseArray forKey:cacheDateStr];
        }
    }
    
    return resultDic;
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

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.recordKeysArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *dateStr = [self.recordKeysArray objectAtIndex:section];
    NSArray *recordArray = [self.sortedGroupRecordDic objectForKey:dateStr];
    
    return recordArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat contentWidth = self.recordTable.frame.size.width - (33 + 20 + 14 + 17);//得到textview宽度
    
    //获得文字内容
    NSArray *dayRecordArray = [self.sortedGroupRecordDic objectForKey:[self.recordKeysArray objectAtIndex:indexPath.section]];
    NSDictionary *dataDic = [dayRecordArray objectAtIndex:indexPath.row];
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
    
    height = height + picGroupHeight + 40;

    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *recordCellId = @"recordcellId";
    //定义标志，保证仅为该表格注册一次单元格视图
    static BOOL recordCellisRegist = NO;
    if (!recordCellisRegist) {
        UINib *nib = [UINib nibWithNibName:@"RecordCell" bundle:nil];
        //注册单元格
        [self.recordTable registerNib:nib forCellReuseIdentifier:recordCellId];
        recordCellisRegist = YES;
    }
    
    RecordCell *tableCell = [tableView dequeueReusableCellWithIdentifier:recordCellId];
    //获取对应的data dic
    NSArray *dayRecordArray = [self.sortedGroupRecordDic objectForKey:[self.recordKeysArray objectAtIndex:indexPath.section]];
    
    NSDictionary *dataDic = [dayRecordArray objectAtIndex:indexPath.row];
    
    //获取文字内容
    NSString *recordContent = [dataDic objectForKey:@"recordContent"];
    tableCell.contentText.text = recordContent;
    
    //图片对应UI
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
        tableCell.picUrlArray  = recordPicsURLArray;
        
        //设置图片
        for (int i = 0; i < [recordPicsURLArray count]; i++) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *picURLStr = recordPicsURLArray[i];
                
                NSString *urlImageKey = [picURLStr lastPathComponent];
                
                //查看缓存中是否存在
                UIImage *cachePic = [self.picCache objectForKey:urlImageKey];
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
                        [self.picCache setObject:shotCutImage forKey:urlImageKey];
                    }
                }
            });
        }
    }
    
    return tableCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    RecordHeaderView *headerView = (RecordHeaderView *)[JerryViewTools getViewByXibName:@"RecordHeader"];
    
    NSString *dateStr = [self.recordKeysArray objectAtIndex:section];
    headerView.dateLabel.text = dateStr;
    
    NSString *calendarStr = [dateStr substringWithRange:NSMakeRange(8, 2)];
    headerView.calendarLabel.text = calendarStr;
    
    //获得NSDATE
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    //获取星期
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger week = [calendar component:NSCalendarUnitWeekday fromDate:date];
    NSString *weekStr;
    switch (week) {
        case 1:
            weekStr = @"星期日";
            break;
        case 2:
            weekStr = @"星期一";
            break;
        case 3:
            weekStr = @"星期二";
            break;
        case 4:
            weekStr = @"星期三";
            break;
        case 5:
            weekStr = @"星期四";
            break;
        case 6:
            weekStr = @"星期五";
            break;
        case 7:
            weekStr = @"星期六";
            break;
    }
    
    headerView.dayLabel.text = weekStr;
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 91;
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
