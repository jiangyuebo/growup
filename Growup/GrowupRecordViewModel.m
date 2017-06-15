//
//  GrowupRecordViewModel.m
//  Growup
//
//  Created by Jerry on 2017/5/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "GrowupRecordViewModel.h"
#import "globalHeader.h"
#import "BMRequestHelper.h"
#import "JerryTools.h"

@implementation GrowupRecordViewModel

#pragma mark 获取成长记列表
- (void)getGrowupRecordByRecordType:(NSString *)recordType andPublicType:(NSString *) publicType andPageIndex:(NSNumber *) pageIndex andPageSize:(NSNumber *) pageSize andIsInfo:(BOOL) isInfo andCallback:(void (^)(NSDictionary *resultDic)) callback{
    //api/v1/record/getAll?recordType={recordType}&publicType={publicType}&isInfo={isInfo}
    NSString *url_request;
    
    //查询自己记录
    if ([JerryTools stringIsNull:recordType] && [JerryTools stringIsNull:publicType]) {
        url_request = [NSString stringWithFormat:@"%@%@?pageIndex=%@&pageSize=%@",URL_REQUEST,URL_REQUEST_GET_GROWUP_RECORD,pageIndex,pageSize];
    }else{
        url_request = [NSString stringWithFormat:@"%@%@?recordType=%@&publicType=%@&pageIndex=%@&pageSize=%@",URL_REQUEST,URL_REQUEST_GET_GROWUP_RECORD,recordType,publicType,pageIndex,pageSize];
    }

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
                
//                NSDictionary *page = [jsonDic objectForKey:@"page"];
//                NSNumber *pageIndex = [page objectForKey:@"pageIndex"];
//                NSNumber *pageSize = [page objectForKey:@"pageSize"];
//                NSNumber *totalCount = [page objectForKey:@"totalCount"];
//                
//                NSArray *records = [jsonDic objectForKey:@"records"];
//                for (int i = 0; i < [records count]; i ++) {
//                    NSDictionary *recordDic = records[i];
//                    NSNumber *childID = [recordDic objectForKey:@"childID"];
//                    NSString *contentResourceTypeKey = [recordDic objectForKey:@"contentResourceTypeKey"];
//                    NSString *publicTypeKey = [recordDic objectForKey:@"publicTypeKey"];
//                    NSDate *publishDate = [recordDic objectForKey:@"publishDate"];
//                    NSString *recordContent = [recordDic objectForKey:@"recordContent"];
//                    NSDate *recordDate = [recordDic objectForKey:@"recordDate"];
//                    NSNumber *recordID = [recordDic objectForKey:@"recordID"];
//                    NSString *recordPublishTypeKey = [recordDic objectForKey:@"recordPublishTypeKey"];
//                    NSString *recordSourceTypeKey = [recordDic objectForKey:@"recordSourceTypeKey"];
//                    NSString *recordTypeKey = [recordDic objectForKey:@"recordTypeKey"];
//                    NSNumber *userID = [recordDic objectForKey:@"userID"];
//                }
                if (jsonDic) {
                    [resultDic setObject:jsonDic forKey:RESULT_KEY_DATA];
                }else{
                    [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
                }
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
        }
        
        callback(resultDic);
    }];
}

#pragma mark 获取橙长记明细
- (void)getRecordDetailByRecordID:(NSString *) recordID andCallback:(void (^)(NSDictionary *resultDic))callback{
    //api/v1/record/get/{recordID}
    NSString *url_request = [NSString stringWithFormat:@"%@%@/%@",URL_REQUEST,URL_RECORD_DETAIL,recordID];
    
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
                
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
            
        }
        
        callback(resultDic);
    }];
    
}

@end
