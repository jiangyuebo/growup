//
//  GrowupRecordViewModel.h
//  Growup
//
//  Created by Jerry on 2017/5/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrowupRecordViewModel : NSObject

#pragma mark 获取成长记列表
- (void)getGrowupRecordByRecordType:(NSString *)recordType andPublicType:(NSString *) publicType andPageIndex:(NSNumber *) pageIndex andPageSize:(NSNumber *) pageSize andIsInfo:(BOOL) isInfo andCallback:(void (^)(NSDictionary *resultDic)) callback;

#pragma mark 获取橙长记明细
- (void)getRecordDetailByRecordID:(NSString *) recordID andCallback:(void (^)(NSDictionary *resultDic))callback;

@end
