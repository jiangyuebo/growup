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

@interface CZinterestingSettingViewController ()

@property (strong, nonatomic) IBOutlet UIButton *singButton;

@property (strong, nonatomic) IBOutlet UIButton *danceButton;

@property (strong, nonatomic) IBOutlet UIButton *scienceButton;

@property (strong, nonatomic) IBOutlet UIButton *sportButton;

@property (strong, nonatomic) IBOutlet UIButton *intelligenceButton;

@property (strong, nonatomic) IBOutlet UIButton *synthesizeButton;

@property (strong,nonatomic) NSMutableArray *selectedCodeArray;


@end

@implementation CZinterestingSettingViewController

@synthesize passDataDic;

- (IBAction)save:(UIButton *)sender {
    
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
    NSMutableArray *selectButtonArray = [[NSMutableArray alloc] init];

    [selectButtonArray addObject:self.singButton];
    [selectButtonArray addObject:self.danceButton];
    [selectButtonArray addObject:self.scienceButton];
    [selectButtonArray addObject:self.sportButton];
    [selectButtonArray addObject:self.intelligenceButton];
    [selectButtonArray addObject:self.synthesizeButton];
    
    for (int i = 0; i < [selectButtonArray count]; i++) {
        UIButton *selectButton = [selectButtonArray objectAtIndex:i];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonSelected:)];
        [selectButton addGestureRecognizer:singleTap];
    }
    
}

- (void)buttonSelected:(UITapGestureRecognizer *) sender{
    UIButton *selectedButton = (UIButton *)sender.view;
    
    if (selectedButton == self.singButton) {
        
        long index = [self.selectedCodeArray indexOfObject:@"D19B01"];
        if (index > -1) {
            //有，取消选择
            [self.selectedCodeArray removeObject:@"D19B01"];
            [self setUnSelect:selectedButton];
        }else{
            //没有，选择
            [self.selectedCodeArray addObject:@"D19B01"];
            [self setSelected:selectedButton];
        }
        
        
    }
}

- (void)setSelected:(UIButton *) selectedButton{
    UIImage *backgroundImage = [UIImage imageNamed:@"select_round_hover"];
    [selectedButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    selectedButton.titleLabel.textColor = [UIColor whiteColor];
    
}

- (void)setUnSelect:(UIButton *) unSelectButton{
    UIImage *backgroundImage = [UIImage imageNamed:@"select_round"];
    [unSelectButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    unSelectButton.titleLabel.textColor = [UIColor grayColor];
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
