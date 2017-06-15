//
//  DiscoverModel.m
//  Growup
//
//  Created by Jerry on 2017/5/12.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "DiscoverViewModel.h"
#import "globalHeader.h"
#import "BMRequestHelper.h"

@implementation DiscoverViewModel

- (void)getDiscoverInfoByAgeType:(NSString *) ageType andInfoTypeKey:(NSString *)infoTypeKey andInfoDetailTypeKey:(NSString *)infoDetailTypeKey andPageIndex:(NSNumber *) pageIndex andPageSize:(NSNumber *) pageSize andCallback:(void (^)(NSDictionary *resultDic)) callback{
    
    //api/v1/info/getAll?ageType={ageType}&infoTypeKey={infoType}&infoDetailTypeKey={infoDetailType}&pageIndex={pageIndex}&pageSize={pageSize}
    NSString *url_request = [NSString stringWithFormat:@"%@%@?ageType=%@&infoType=%@&infoDetailType=%@&pageIndex=%@&pageSize=%@",URL_REQUEST,URL_INFO_GET,ageType,infoTypeKey,infoDetailTypeKey,pageIndex,pageSize];
    
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
