//
//  CZChangeUserNickNameViewController.m
//  Growup
//
//  Created by Jerry on 2017/6/2.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZChangeUserNickNameViewController.h"
#import "CZPersonCenterViewModel.h"
#import "JerryViewTools.h"
#import "JerryTools.h"
#import "globalHeader.h"

@interface CZChangeUserNickNameViewController ()

@end

@implementation CZChangeUserNickNameViewController

@synthesize passDataDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断操作类型
    NSString *type = [passDataDic objectForKey:TYPE_KEY];
    if ([type isEqualToString:TYPE_VALUE_NICKNAME]) {
        self.title = @"修改昵称";
        NSString *nickname = [passDataDic objectForKey:@"nickname"];
        self.userNicknameText.text = nickname;
    }
    
    if ([type isEqualToString:TYPE_VALUE_CHILD_NICKNAME]) {
        self.title = @"修改孩子昵称";
        NSString *childNickname = [passDataDic objectForKey:@"childNickName"];
        self.userNicknameText.text = childNickname;
    }
    
    if ([type isEqualToString:TYPE_VALUE_CHILD_ADDRESS]) {
        self.title = @"常住地";
        self.userNicknameText.placeholder = @"常住地";
        NSString *childNickname = [passDataDic objectForKey:@"familyAddress"];
        self.userNicknameText.text = childNickname;
    }
    
    if ([type isEqualToString:TYPE_VALUE_CHILD_SCHOOL]) {
        self.title = @"就读学校";
        self.userNicknameText.placeholder = @"就读学校";
        NSString *schoolAddress = [passDataDic objectForKey:@"schoolAddress"];
        self.userNicknameText.text = schoolAddress;
    }
    
    [JerryViewTools setCZTextField:self.userNicknameText];
}

- (void)dealloc{
    //修改用户昵称
    NSString *type = [passDataDic objectForKey:TYPE_KEY];
    if ([type isEqualToString:TYPE_VALUE_NICKNAME]) {
        NSString *nickname;
        //提交修改
        if ([JerryTools stringIsNull:self.userNicknameText.text]) {
            //昵称为空
            nickname = @"橙子先生";
        }else{
            //昵称不为空
            nickname = self.userNicknameText.text;
        }
        
        CZPersonCenterViewModel *modelView = [[CZPersonCenterViewModel alloc] init];
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        [infoDic setObject:nickname forKey:@"nickName"];
        
        [modelView changeUserInfo:infoDic andCallback:^(NSDictionary *resultDic) {
            
        }];
    }
    
    if ([type isEqualToString:TYPE_VALUE_CHILD_NICKNAME]) {
        //修改孩子昵称
        NSString *nickname;
        //提交修改
        if ([JerryTools stringIsNull:self.userNicknameText.text]) {
            //昵称为空
            nickname = @"小橙子";
        }else{
            //昵称不为空
            nickname = self.userNicknameText.text;
        }
        
        CZPersonCenterViewModel *modelView = [[CZPersonCenterViewModel alloc] init];
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *changeDic = [NSMutableDictionary dictionary];
        [changeDic setObject:nickname forKey:@"nickName"];
        
        [infoDic setObject:changeDic forKey:@"child"];
        
        [modelView changeChildInfo:infoDic andCallback:^(NSDictionary *resultDic) {
            
        }];
    }
    
    if ([type isEqualToString:TYPE_VALUE_CHILD_ADDRESS]) {
        //修改地址
        NSString *address;
        //提交修改
        if ([JerryTools stringIsNull:self.userNicknameText.text]) {
            //地址为空
            address = @"";
        }else{
            //地址不为空
            address = self.userNicknameText.text;
        }
        
        CZPersonCenterViewModel *modelView = [[CZPersonCenterViewModel alloc] init];
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *changeDic = [NSMutableDictionary dictionary];
        [changeDic setObject:address forKey:@"familyAddress"];
        
        [infoDic setObject:changeDic forKey:@"child"];
        
        [modelView changeChildInfo:infoDic andCallback:^(NSDictionary *resultDic) {
            
        }];
    }
    
    if ([type isEqualToString:TYPE_VALUE_CHILD_SCHOOL]) {
        //修改学校地址
        NSString *schoolAddrress;
        //提交修改
        if ([JerryTools stringIsNull:self.userNicknameText.text]) {
            //地址为空
            schoolAddrress = @"";
        }else{
            //地址不为空
            schoolAddrress = self.userNicknameText.text;
        }
        
        CZPersonCenterViewModel *modelView = [[CZPersonCenterViewModel alloc] init];
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *changeDic = [NSMutableDictionary dictionary];
        [changeDic setObject:schoolAddrress forKey:@"schoolAddress"];
        
        [infoDic setObject:changeDic forKey:@"child"];
        
        [modelView changeChildInfo:infoDic andCallback:^(NSDictionary *resultDic) {
            
        }];
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
