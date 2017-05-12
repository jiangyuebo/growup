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

@interface CZGrowupRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) GrowupRecordViewModel *viewModel;

@property (strong, nonatomic) IBOutlet UITableView *recordTable;

@property (strong,nonatomic) NSMutableArray *recordsArray;

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
            [self sortOutRecordListData:[result objectForKey:@"records"]];
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordsArray.count;
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
    NSDictionary *dataDic = [self.recordsArray objectAtIndex:indexPath.row];
    
    NSString *recordContent = [dataDic objectForKey:@"recordContent"];
    
    tableCell.contentText.text = recordContent;
    
    return tableCell;
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
