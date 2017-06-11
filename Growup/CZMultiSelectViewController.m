//
//  CZMultiSelectViewController.m
//  Growup
//
//  Created by Jerry on 2017/6/11.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZMultiSelectViewController.h"
#import "globalHeader.h"
#import "CZMultiSelectView.h"
#import "CZPersonCenterViewModel.h"

@interface CZMultiSelectViewController ()

@property (strong,nonatomic) CZMultiSelectView *multiSelectView;

@end

@implementation CZMultiSelectViewController

@synthesize passDataDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *type = [passDataDic objectForKey:TYPE_KEY];
    
    if ([type isEqualToString:TYPE_VALUE_CHILD_INTEREST]) {
        self.title = @"孩子兴趣";
        
        //获取默认值
        NSString *selectedItems = [passDataDic objectForKey:@"interestTypes"];
        NSArray *temp = [selectedItems componentsSeparatedByString:@","];
        
        self.multiSelectView = [[CZMultiSelectView alloc] initWithFrame:CGRectMake(0,8, SCREENWIDTH,180)];
        
        NSMutableDictionary *selectItemsDic = [NSMutableDictionary dictionary];
        [selectItemsDic setObject:Interest_sing forKey:@"唱歌"];
        [selectItemsDic setObject:Interest_dance forKey:@"跳舞"];
        [selectItemsDic setObject:Interest_sci forKey:@"科学"];
        [selectItemsDic setObject:Interest_sport forKey:@"运动"];
        [selectItemsDic setObject:Interest_clear forKey:@"智力"];
        
        [self.multiSelectView setSelectItemDic:selectItemsDic];
        //设置默认选中
        [self.multiSelectView setDefaultSelectedItems:temp];
        
        [self.view addSubview:self.multiSelectView];
    }
}

- (void)dealloc{
    NSString *type = [passDataDic objectForKey:TYPE_KEY];
    
    if ([type isEqualToString:TYPE_VALUE_CHILD_INTEREST]) {
        //修改孩子兴趣
        NSArray *selectedInterests = self.multiSelectView.selectedItems;
        //NSArray --> NSString
        NSString *interestsStr = @"";
        if (selectedInterests) {
            if ([selectedInterests count] > 0) {
                for (int i = 0; i < [selectedInterests count]; i++) {
                    interestsStr = [interestsStr stringByAppendingString:[NSString stringWithFormat:@"%@,",selectedInterests[i]]];
                }
                interestsStr = [interestsStr substringToIndex:([interestsStr length] - 1)];
                NSLog(@"interestsStr = [%@]",interestsStr);
            }
            
            CZPersonCenterViewModel *modelView = [[CZPersonCenterViewModel alloc] init];
            
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
            
            NSMutableDictionary *changeDic = [NSMutableDictionary dictionary];
            [changeDic setObject:interestsStr forKey:@"interestTypes"];
            
            [infoDic setObject:changeDic forKey:@"child"];
            
            [modelView changeChildInfo:infoDic andCallback:^(NSDictionary *resultDic) {
                
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
