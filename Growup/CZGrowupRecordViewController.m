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

@interface CZGrowupRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) GrowupRecordViewModel *viewModel;

@property (strong, nonatomic) IBOutlet UITableView *recordTable;

@property (strong,nonatomic) NSMutableArray *recordsArray;

@property (strong,nonatomic) NSMutableDictionary *sortedGroupRecordDic;

@property (strong,nonatomic) NSArray *recordKeysArray;

@property (strong,nonatomic) NSMutableDictionary *recordGroupData;

@end

@implementation CZGrowupRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
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
    
    self.viewModel = [[GrowupRecordViewModel alloc] init];
    
    self.recordGroupData = [NSMutableDictionary dictionary];

}

- (void)initView{
    self.recordTable.separatorStyle = NO;
    self.recordTable.allowsSelection = NO;
}

#pragma mark 查看自己橙长记
- (void)loadSelfRecord{
    
    [self.viewModel getGrowupRecordByRecordType:nil andPublicType:nil andIsInfo:NO andCallback:^(NSDictionary *resultDic) {
        
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
            
            //设置橙长记列表数组
//            [self sortOutRecordListData:[result objectForKey:@"records"]];
            
            NSArray *recordArray = [result objectForKey:@"records"];
            recordArray = [[recordArray reverseObjectEnumerator] allObjects];
            self.sortedGroupRecordDic = [self sortOutRecordToGroupData:recordArray];
            
            self.recordKeysArray = [self.sortedGroupRecordDic allKeys];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
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
                [resultDic setValue:dateRecord forKey:cacheDateStr];
            }
            
            //创建新的
            dateRecord = [[NSMutableArray alloc] init];
            cacheDateStr = dateStr;
        }
        //放入
        [dateRecord addObject:dataDic];
        
        //最后一组
        if (i == ([recordArray count] -1)) {
            [resultDic setValue:dateRecord forKey:cacheDateStr];
        }
    }
    
    return resultDic;
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
    return 150;
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
    
    NSString *recordContent = [dataDic objectForKey:@"recordContent"];
    
    tableCell.contentText.text = recordContent;
    
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
