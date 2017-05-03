//
//  FastTestViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/13.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "FastTestViewController.h"
#import "FastTestViewModel.h"
#import "KidInfoModel.h"
#import "UserInfoModel.h"
#import "JerryTools.h"
#import "globalHeader.h"
#import "TestModel.h"
#import "TestSubjectModel.h"

@interface FastTestViewController ()

@property (strong,nonatomic) NSMutableArray *answerCollection;

@property (strong,nonatomic) FastTestViewModel *viewModel;

@property (strong,nonatomic) TestModel *testModel;

@property (strong,nonatomic) NSArray *subjectsArray;

//背景图
@property (strong, nonatomic) IBOutlet UIImageView *contentImage;

@property (strong, nonatomic) IBOutlet UILabel *subjectTile;

@property (strong, nonatomic) IBOutlet UILabel *subjectSubtitle;

@property (strong, nonatomic) IBOutlet UILabel *count;

@end

@implementation FastTestViewController

int currentSubjectIndex = 0;

- (IBAction)optionAClicked:(UIButton *)sender {
    [self selectedOption:[NSNumber numberWithInt:1] andResultType:@"D46B01"];
}

- (IBAction)optionBClicked:(UIButton *)sender {
    [self selectedOption:[NSNumber numberWithInt:2] andResultType:@"D46B02"];
}

- (IBAction)optionCClicked:(UIButton *)sender {
    [self selectedOption:[NSNumber numberWithInt:3] andResultType:@"D46B03"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
}

- (void)initView{
    
}

- (void)initData{
    self.answerCollection = [[NSMutableArray alloc] init];
    
    //获取题目
    self.viewModel = [[FastTestViewModel alloc] init];
    
    UserInfoModel *currentUser = [JerryTools getUserInfoModel];
    NSArray *childArray = [currentUser childArray];
    if ([childArray count] > 0) {
        KidInfoModel *kidModelInfo = [childArray objectAtIndex:currentUser.currentSelectedChild];
        NSNumber *childId = [kidModelInfo childID];
        NSString *ageTypeKey = [kidModelInfo ageTypeKey];
        NSString *evaluationType = @"D24B99";
        NSNumber *sex = [kidModelInfo sex];
        
        //WILL DELETE ->  test
        sex = [NSNumber numberWithInt:1];
        
        [self.viewModel getTestSubjectByChildId:childId andAgeType:ageTypeKey andEvaluationType:evaluationType andSex:sex andCallback:^(NSDictionary *resultDic) {
            
            NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
            if (errorMessage) {
                //出错
            }else{
                //拿到题目
                self.testModel = [resultDic objectForKey:RESULT_KEY_DATA];
                
                self.subjectsArray = [self.testModel subjectsArray];
                
                currentSubjectIndex = 0;
                
                if ([self.subjectsArray count] > 0) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self startTestShow];
                    });
                }
            }
        }];
    }
}

#pragma mark 开始测试
- (void)startTestShow{
    //设置标题
    NSString *title = [self.testModel evaluationName];
    self.title = title;
    
    [self showSubjectByIndex:currentSubjectIndex];
}

#pragma mark 根据序列号展现题目
- (void)showSubjectByIndex:(int) subjectIndex{
    
    NSUInteger totalCount = [self.subjectsArray count];
    
    NSString *countStr = [NSString stringWithFormat:@"%d/%ld",(subjectIndex + 1),totalCount];
    self.count.text = countStr;
    
    TestSubjectModel *testSubjectModel = [self.subjectsArray objectAtIndex:subjectIndex];
    NSString *subjectName = [testSubjectModel subjectName];
    NSString *subjectDescription = [testSubjectModel subjectDescription];
    
    self.subjectTile.text = subjectName;
    self.subjectSubtitle.text = subjectDescription;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedOption:(NSNumber *)optionId andResultType:(NSString *) resultType{
    
    //获取当前题目数据
    TestSubjectModel *subjectModel = [self.subjectsArray objectAtIndex:currentSubjectIndex];
    
    NSNumber *evaluationSubjectID = [subjectModel evaluationSubjectID];
    NSNumber *evaluationID = [self.testModel evaluationID];
    NSNumber *subjectID = [subjectModel subjectID];
    NSNumber *optionID = optionId;
    NSString *subjectOptionTypeKey = @"D23B01";
    NSString *optionResultTypeKey = resultType;
    
    NSMutableDictionary *anwserDic = [NSMutableDictionary dictionary];
    [anwserDic setObject:evaluationSubjectID forKey:@"evaluationSubjectID"];
    [anwserDic setObject:evaluationID forKey:@"evaluationID"];
    [anwserDic setObject:subjectID forKey:@"subjectID"];
    [anwserDic setObject:optionID forKey:@"optionID"];
    [anwserDic setObject:subjectOptionTypeKey forKey:@"subjectOptionTypeKey"];
    [anwserDic setObject:optionResultTypeKey forKey:@"optionResultTypeKey"];
    
    [self.answerCollection addObject:anwserDic];
    
    currentSubjectIndex++;
    
    if (currentSubjectIndex == [self.subjectsArray count]) {
        //题目做完
        NSLog(@"题目做完");
        currentSubjectIndex = 0;
        
        NSNumber *evaluationID = [self.testModel evaluationID];
        
        [self.viewModel sendTestAnwserToServerByEvaluationID:evaluationID andAnwserArray:self.answerCollection andCallback:^(NSDictionary *resultDic) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //返回首页
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }else{
        //下一题
        [self showSubjectByIndex:currentSubjectIndex];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
