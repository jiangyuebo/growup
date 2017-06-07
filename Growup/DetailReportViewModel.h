//
//  DetailReportViewModel.h
//  Growup
//
//  Created by Jerry on 2017/6/5.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailReportViewModel : NSObject

#pragma mark 获取综合评测报告
- (void)queryDetailReportDataByAbilityID:(NSNumber *) abilityID andCallback:(void (^)(NSDictionary * resultDic)) callback;

@end
