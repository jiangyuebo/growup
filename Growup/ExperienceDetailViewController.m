//
//  ExperienceDetailViewController.m
//  Growup
//
//  Created by Jerry on 2017/5/13.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "ExperienceDetailViewController.h"
#import "ExperienceViewModel.h"
#import "JerryViewTools.h"
#import "globalHeader.h"

@interface ExperienceDetailViewController ()

@property (strong,nonatomic) ExperienceViewModel *viewModel;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ExperienceDetailViewController

@synthesize dataDic;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[ExperienceViewModel alloc] init];
    NSLog(@"dataDic : %@",dataDic);
    
//    [self.viewModel getExperienceDetailByID:[dataDic objectForKey:@"experienceID"] andCallback:^(NSDictionary *resultDic) {
//        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
//        if (errorMessage) {
//            //error
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
//            });
//        }else{
//            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
//            NSString *url = [result objectForKey:@"url"];
//            
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                self.title = [result objectForKey:@"experienceName"];
//                
//                NSURL *nsurl = [NSURL URLWithString:url];
//                NSData *urlData = [NSData dataWithContentsOfURL:nsurl];
//                [self.webView loadData:urlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nsurl];
//            });
//        }
//    }];
    
    NSString *url = [dataDic objectForKey:@"url"];
    self.title = [dataDic objectForKey:@"experienceName"];
        
    NSURL *nsurl = [NSURL URLWithString:url];
    NSData *urlData = [NSData dataWithContentsOfURL:nsurl];
    [self.webView loadData:urlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nsurl];
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
