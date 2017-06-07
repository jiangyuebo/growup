//
//  CZPersonCenterViewModel.h
//  Growup
//
//  Created by Jerry on 2017/6/2.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZPersonCenterViewModel : NSObject

#pragma mark 修改用户信息
- (void)changeUserInfo:(NSMutableDictionary *) userInfoDic andCallback:(void (^)(NSDictionary * resultDic)) callback;

#pragma mark 修改孩子信息
//- (void)changeChildInfoById:(NSNumber *) childId 

@end
