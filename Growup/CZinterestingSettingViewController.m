//
//  CZinterestingSettingViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/20.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZinterestingSettingViewController.h"
#import "globalHeader.h"
#import "JerryViewTools.h"
#import "InterestingSettingViewModel.h"
#import "CZMultiSelectView.h"

@interface CZinterestingSettingViewController ()

//@property (strong, nonatomic) IBOutlet UIButton *singButton;
//
//@property (strong, nonatomic) IBOutlet UIButton *danceButton;
//
//@property (strong, nonatomic) IBOutlet UIButton *scienceButton;
//
//@property (strong, nonatomic) IBOutlet UIButton *sportButton;
//
//@property (strong, nonatomic) IBOutlet UIButton *intelligenceButton;
//
//@property (strong, nonatomic) IBOutlet UIButton *synthesizeButton;

@property (strong,nonatomic) NSMutableArray *selectedCodeArray;

@property (strong,nonatomic) CZMultiSelectView *multiSelectView;

@end

@implementation CZinterestingSettingViewController

@synthesize passDataDic;

- (IBAction)save:(UIButton *)sender {
    
    NSArray *selectedInterests = self.multiSelectView.selectedItems;
    //NSArray --> NSString
    NSString *interestsStr = @"";
    if (selectedInterests) {
        if ([selectedInterests count] > 0) {
            for (int i = 0; i < [selectedInterests count]; i++) {
                interestsStr = [interestsStr stringByAppendingString:[NSString stringWithFormat:@"%@,",selectedInterests[i]]];
            }
            interestsStr = [interestsStr substringToIndex:([interestsStr length] - 1)];
        }
    }
    
    [self.passDataDic setObject:interestsStr forKey:COLUMN_INTEREST];
    
    InterestingSettingViewModel *viewModel = [[InterestingSettingViewModel alloc] init];
    [viewModel setChildSetting:self.passDataDic andJumpTo:^(NSString *address) {
        //回弹到首页
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[self navigationController] popToRootViewControllerAnimated:YES];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView{
    //初始化多选按钮
    [self initCollectionButton];
}

#pragma mark 初始化多选按钮
- (void)initCollectionButton{
    
    self.multiSelectView = [[CZMultiSelectView alloc] initWithFrame:CGRectMake(0,8, SCREENWIDTH,180)];
    
    NSMutableDictionary *selectItemsDic = [NSMutableDictionary dictionary];
    [selectItemsDic setObject:Interest_sing forKey:@"唱歌"];
    [selectItemsDic setObject:Interest_dance forKey:@"跳舞"];
    [selectItemsDic setObject:Interest_sci forKey:@"科学"];
    [selectItemsDic setObject:Interest_sport forKey:@"运动"];
    [selectItemsDic setObject:Interest_clear forKey:@"智力"];
    
    [self.multiSelectView setSelectItemDic:selectItemsDic];
    
    [self.view addSubview:self.multiSelectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
