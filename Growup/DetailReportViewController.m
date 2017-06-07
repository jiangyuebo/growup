//
//  DetailReportViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/8.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "DetailReportViewController.h"
#import "DetailReportViewModel.h"
#import "globalHeader.h"
#import "JerryViewTools.h"
#import "DetailReportCell.h"

@interface DetailReportViewController ()

@property (nonatomic) BOOL isDetailReportCellRegister;

@property (strong,nonatomic) NSArray *detailReportArray;

@property (strong,nonatomic) UIView *headerView;

@end

@implementation DetailReportViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isDetailReportCellRegister = NO;
    
    [self initView];
    
    [self loadData];
}

- (void)initView{
    
    self.detailReportTable.delegate = self;
    self.detailReportTable.dataSource = self;
    
    //设置头
    self.headerView = [JerryViewTools getViewByXibName:@"DetailReportHeader"];
    self.detailReportTable.tableHeaderView = self.headerView;
}

- (void)loadData{
    DetailReportViewModel *viewModel = [[DetailReportViewModel alloc] init];
    [viewModel queryDetailReportDataByAbilityID:[NSNumber numberWithInt:1] andCallback:^(NSDictionary *resultDic) {
        
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            //头部内容控件
            UILabel *titleGrade = [self.headerView viewWithTag:1];
            
            UITextView *titleDescription = [self.headerView viewWithTag:2];
            
            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
            //综合等级
            NSString *adviseGradeTypeKey = [result objectForKey:@"adviseGradeTypeKey"];
            NSString *gradeStr;
            if ([adviseGradeTypeKey isEqualToString:@"D47B01"]) {
                //A
                gradeStr = @"A";
            }else if ([adviseGradeTypeKey isEqualToString:@"D47B02"]){
                //B
                gradeStr = @"B";
            }else if ([adviseGradeTypeKey isEqualToString:@"D47B03"]){
                //C
                gradeStr = @"C";
            }
            
            //头部建议
            NSString *description = [result objectForKey:@"description"];
            
            //获取各项报告
            self.detailReportArray = [result objectForKey:@"userAbilityDetails"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                //这设置标题等级
                titleGrade.text = gradeStr;
                //标题建议
                titleDescription.text = description;
                
                [self.detailReportTable reloadData];
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

#pragma mark table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.detailReportArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 380;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *detailReportCellId = @"detailReportCellId";
    
    if (!self.isDetailReportCellRegister) {
        UINib *nib = [UINib nibWithNibName:@"DetailReportCell" bundle:nil];
        //注册单元格
        [self.detailReportTable registerNib:nib forCellReuseIdentifier:detailReportCellId];
        self.isDetailReportCellRegister = YES;
    }
    
    DetailReportCell *tableCell = [tableView dequeueReusableCellWithIdentifier:detailReportCellId];
    
    //获取数据
    NSDictionary *itemDic = self.detailReportArray[indexPath.row];
    //获取指标项名称
    NSDictionary *abilityDic = [itemDic objectForKey:@"ability"];
    NSString *abilityName = [abilityDic objectForKey:@"abilityName"];
    tableCell.titleLabel.text = abilityName;
    
    //柱状图相关
    NSString *adviseTotalStr = @"";
    NSArray *pillarsDataArray = [itemDic objectForKey:@"parentUserAbilityDetails"];
    for (int i = 0; i < [pillarsDataArray count]; i++) {
        NSDictionary *pillarDataDic = pillarsDataArray[i];
        
        //获取柱子底部标题
        NSDictionary *pillarAbilityDic = [pillarDataDic objectForKey:@"ability"];
        NSString *abilityName = [pillarAbilityDic objectForKey:@"abilityName"];
        
        NSString *keyPath = [NSString stringWithFormat:@"pillarLabel%d.text",(i + 1)];
        
        [tableCell setValue:abilityName forKeyPath:keyPath];
        
        //建议
        NSString *adviseStr = [pillarDataDic objectForKey:@"adviseDescription"];
        NSString *advise = [NSString stringWithFormat:@"%d.%@ \n",(i + 1),adviseStr];
        adviseTotalStr = [adviseTotalStr stringByAppendingString:advise];
        NSLog(@"adviseTotalStr : %@",adviseTotalStr);
        
        //获取分数
        //初始化健康柱子
//        UIImage *jkPillarImage = [[UIImage imageNamed:@"pillar_defaut"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 0, 0,0)];
        
        NSNumber *pillarScore = [pillarDataDic objectForKey:@"score"];
        NSLog(@"abilityName : %@ ,pillarScore : %@",abilityName,pillarScore);
        
        if (i == 0) {
            tableCell.pillarHeight1.constant = 150;
//            [tableCell.pillarImageView1 setImage:jkPillarImage];
            [tableCell movePillarView:tableCell.pillarImageView1 andPillarViewConstant:tableCell.pillarHeight1 ByValue:[pillarScore intValue]];
        }
        
        if (i == 1) {
            tableCell.pillarHeight2.constant = 150;
//            [tableCell.pillarImageView2 setImage:jkPillarImage];
            [tableCell movePillarView:tableCell.pillarImageView2 andPillarViewConstant:tableCell.pillarHeight2 ByValue:[pillarScore intValue]];
        }
        
        if (i == 2) {
            tableCell.pillarHeight3.constant = 150;
//            [tableCell.pillarImageView3 setImage:jkPillarImage];
            [tableCell movePillarView:tableCell.pillarImageView3 andPillarViewConstant:tableCell.pillarHeight3 ByValue:[pillarScore intValue]];
        }
    }
    
    //柱子信息少于3条情况处理，第三条填空
    if ([pillarsDataArray count] < 3) {
        tableCell.pillarLabel3.text = @"";
        tableCell.pillarHeight3.constant = 0;
    }
    
    tableCell.suggestLabel.text = adviseTotalStr;
    
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
