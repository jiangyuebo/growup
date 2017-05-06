//
//  TrackUploadModel.h
//  Growup
//
//  Created by Jerry on 2017/5/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackUploadModel : NSObject

#pragma mark 发布橙长记
- (void)sendRecord:(NSDictionary *) dataDic andCallback:(void (^)(NSDictionary *resultDic)) callback;

@end
