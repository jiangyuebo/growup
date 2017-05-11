//
//  TrackUploadModel.m
//  Growup
//
//  Created by Jerry on 2017/5/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "TrackUploadModel.h"
#import "globalHeader.h"
#import "BMRequestHelper.h"

@implementation TrackUploadModel

#pragma mark 发布橙长记
- (void)sendRecord:(NSDictionary *) dataDic andCallback:(void (^)(NSDictionary *resultDic)) callback{
    NSString *url_request = [NSString stringWithFormat:@"%@%@",URL_REQUEST,URL_RECORD_UPLOAD];
    
    BMRequestHelper *requestHelper = [[BMRequestHelper alloc] init];
    [requestHelper postRequestAsynchronousToUrl:url_request byParamsDic:dataDic needAccessToken:YES andCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        
        if (data) {
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSString *errorMessage = [jsonDic objectForKey:@"errorMsg"];
            
            if (errorMessage) {
                //有错误
                [resultDic setObject:errorMessage forKey:RESULT_KEY_ERROR_MESSAGE];
            }else{
                [resultDic setObject:@"success" forKey:RESULT_KEY_DATA];
            }
        }else{
            [resultDic setObject:RESPONSE_ERROR_MESSAGE_NIL forKey:RESULT_KEY_ERROR_MESSAGE];
            
        }
        
        callback(resultDic);
        
    }];
}

@end
