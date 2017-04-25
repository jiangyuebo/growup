//
//  InterestingSettingViewModel.h
//  Growup
//
//  Created by Jerry on 2017/4/22.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterestingSettingViewModel : NSObject

- (void)setChildSetting:(NSDictionary *) settingDataDic andJumpTo:(void (^)(NSString *address)) callbak;

@end
