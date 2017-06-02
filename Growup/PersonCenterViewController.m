//
//  PersonCenterViewController.m
//  Growup
//
//  Created by Jerry on 2017/5/27.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "JerryTools.h"
#import "JerryViewTools.h"
#import "CZLoginViewController.h"
#import "globalHeader.h"
#import "MainPageViewModel.h"

@interface PersonCenterViewController ()

@property (strong,nonatomic) UIBarButtonItem *btnLoginOut;

@property (strong, nonatomic) IBOutlet UILabel *userNickname;

@property (strong, nonatomic) IBOutlet UILabel *userGender;

@property (strong, nonatomic) IBOutlet UILabel *childNickname;

@property (strong, nonatomic) IBOutlet UILabel *childGender;

@property (strong, nonatomic) IBOutlet UILabel *childBirthday;

@property (strong, nonatomic) IBOutlet UILabel *childInteresting;

@property (strong, nonatomic) IBOutlet UILabel *childHomeAddress;

@property (strong, nonatomic) IBOutlet UILabel *childSchool;

@property (strong, nonatomic) IBOutlet UILabel *childTarget;

@end

@implementation PersonCenterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChanged) name:NOTIFICATION_NAME_REFRESH_USER_INFO object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_NAME_REFRESH_USER_INFO object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //添加发送按钮
    self.btnLoginOut = [[UIBarButtonItem alloc]
                       initWithTitle:@"退出登录"
                       style:UIBarButtonItemStylePlain
                       target:self
                       action:@selector(loginOutAction)];
    
    self.navigationItem.rightBarButtonItem = self.btnLoginOut;
    
    [self loadData];
}

- (void)dataChanged{
    [self loadData];
}

- (void)loadData{
    //读取用户资料
    NSString *accessToken = [JerryTools readInfo:SAVE_KEY_ACCESS_TOKEN];
    
    MainPageViewModel *mainPageViewModel = [[MainPageViewModel alloc] init];
    
    [mainPageViewModel getUserInfoDicByAccesstoken:accessToken andCallback:^(NSDictionary *resultDic) {
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSDictionary *result = [resultDic objectForKey:RESULT_KEY_DATA];
            
            NSString *nickName = [result objectForKey:@"nickName"];
            
            //            NSString *avatarUrl = [result objectForKey:@"avatarUrl"];
            
            //            NSNumber *userGender = [result objectForKey:@""];
            
            //            NSString *childNickname = [result objectForKey:@""];
            
            NSNumber *childGender = [[result objectForKey:@"child"] objectForKey:@"sex"];
            
            NSString *childBirthday = [[result objectForKey:@"child"] objectForKey:@"birthdayTS"];
            childBirthday = [childBirthday substringWithRange:NSMakeRange(0, 10)];
            
            //            NSString *childInteresting = [[resultDic objectForKey:@"child"] objectForKey:@"sex"];
            
            //            NSString *childHomeAddress
            
            //            NSString *childSchool
            
            //            NSString *childTarget
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.userNickname.text = nickName;
                
                if ([childGender intValue] == 1) {
                    self.childGender.text = @"男孩";
                }else{
                    self.childGender.text = @"女孩";
                }
                
                self.childBirthday.text = childBirthday;
            });
        }
    }];
}

#pragma mark 退出登录
- (void)loginOutAction{
    NSString *alertTile = @"提示";
    NSString *alertMessage = @"确定要退出当前登录？";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTile message:alertMessage preferredStyle:UIAlertControllerStyleActionSheet];
    //添加按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self loginOut];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (void)loginOut{
    //退出登录
    //删除本地用户信息
    [JerryTools eraseUserLoginStatus];
    //跳转至登录页面
    CZLoginViewController *loginViewController = [JerryViewTools getViewControllerById:IdentifyNameLoginViewController];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath : %ld",indexPath.row);
    
    if (indexPath.row == 1) {
        //修改用户昵称
        
        NSString *nickname = self.userNickname.text;
        NSLog(@"发送方 nickname = %@",nickname);
        
        NSMutableDictionary *passDic = [NSMutableDictionary dictionary];
        [passDic setObject:nickname forKey:@"nickname"];
        
        [JerryViewTools jumpFrom:self ToViewController:IdentifyNameChangeUserNickNameViewController carryDataDic:passDic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
