//
//  ExperienceDetailViewController.m
//  Growup
//
//  Created by Jerry on 2017/5/13.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "ExperienceDetailViewController.h"
#import "ExperienceViewModel.h"

@interface ExperienceDetailViewController ()

@property (strong,nonatomic) ExperienceViewModel *viewModel;

@end

@implementation ExperienceDetailViewController

@synthesize dataDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[ExperienceViewModel alloc] init];
    
    [self.viewModel getExperienceDetailByID:[dataDic objectForKey:@"experienceID"] andCallback:^(NSDictionary *resultDic) {
        
    }];
    
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
