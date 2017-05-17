//
//  DiscoverModel.h
//  Growup
//
//  Created by Jerry on 2017/5/12.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverViewModel : NSObject

#pragma mark 获取资讯信息
- (void)getDiscoverInfoByAgeType:(NSString *) ageType andInfoTypeKey:(NSString *)infoTypeKey andInfoDetailTypeKey:(NSString *)infoDetailTypeKey andPageIndex:(NSNumber *) pageIndex andPageSize:(NSNumber *) pageSize andCallback:(void (^)(NSDictionary *resultDic)) callback;



@end
