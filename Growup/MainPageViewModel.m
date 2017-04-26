//
//  MainPageViewModel.m
//  Growup
//
//  Created by Jerry on 2017/3/2.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "MainPageViewModel.h"
#import "globalHeader.h"
#import "BMRequestHelper.h"

@implementation MainPageViewModel

@synthesize userId,age,ageStr,needTest,score,taskCount,taskFinish,tasks,recommends,adurl;

//更新数据
- (void)updateData{
    //请求网络获取数据
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper getRequestAsynchronousToUrl:RequestMainPageData andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //解析 NSData --> NSDictionary(JSON)
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *adurl_server = [jsonDict objectForKey:@"adurl"];
        adurl = adurl_server;
        NSLog(@"adurl = %@",adurl);
        
        NSNumber *age_server = [jsonDict objectForKey:@"age"];
        self.age = age_server;
        NSLog(@"adurl = %@",age);
        
        NSString *ageStr_server = [jsonDict objectForKey:@"ageStr"];
        self.ageStr = ageStr_server;
        NSLog(@"ageStr = %@",ageStr);
        
        NSArray *recommends_server = [jsonDict objectForKey:@"recommends"];
        self.recommends = recommends_server;
        
        NSDictionary *score_server = [jsonDict objectForKey:@"score"];
        self.score = score_server;
        
        NSNumber *taskCount_server = [jsonDict objectForKey:@"taskCount"];
        self.taskCount = taskCount_server;
        
        NSNumber *taskFinish_server = [jsonDict objectForKey:@"taskFinish"];
        self.taskFinish = taskFinish_server;
        
        NSArray *tasks_server = [jsonDict objectForKey:@"tasks"];
        self.tasks = tasks_server;
        
        NSString *userId_server = [jsonDict objectForKey:@"userId"];
        self.userId = userId_server;
    }];
}

#pragma mark 根据孩子信息获取数据
- (void)getChildInfoById:(NSNumber *) childId andDynamicId:(NSString *) dynamicId{
    
    //getDynamic?childID={childID}&dynamicID={dynamicID}
    NSString *url_request = [NSString stringWithFormat:@"%@%@?childID=%@&dynamicID=%@",URL_REQUEST,URL_REQUEST_CHILD_GET_DYNAMIC,childId,dynamicId];
    
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper getRequestAsynchronousToUrl:url_request andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"jsonDic = %@",jsonDic);
            
            //expiredIn
            //phoneNumber
            //verifyCode
            //verifyTypeKey
            
        }else{
            NSLog(@"返回值中 data 是空");
        }
    }];
}

@end
