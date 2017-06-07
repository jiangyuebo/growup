//
//  DetailReportViewModel.m
//  Growup
//
//  Created by Jerry on 2017/6/5.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "DetailReportViewModel.h"
#import "globalHeader.h"
#import "BMRequestHelper.h"

@implementation DetailReportViewModel

#pragma mark 获取综合评测报告
- (void)queryDetailReportDataByAbilityID:(NSNumber *) abilityID andCallback:(void (^)(NSDictionary * resultDic)) callback{
    
    NSString *url_request = [NSString stringWithFormat:@"%@%@/%@",URL_REQUEST,URL_REQUEST_DETAIL_REPORT_DATA,abilityID];
    NSLog(@"获取综合评测报告 url : %@",url_request);
    
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper getRequestAsynchronousToUrl:url_request andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        
        if (data) {
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSString *errorMessage = [jsonDic objectForKey:@"errorMsg"];
            
            if (errorMessage) {
                //有错误
                [resultDic setObject:errorMessage forKey:RESULT_KEY_ERROR_MESSAGE];
            }else{
                [resultDic setObject:jsonDic forKey:RESULT_KEY_DATA];
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
            
        }
        
        callback(resultDic);
        
    }];
}

@end
