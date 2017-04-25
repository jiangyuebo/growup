//
//  FileCommonTool.h
//  Growup
//
//  Created by Jerry on 2017/3/1.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileCommonTool : NSObject
#pragma mark 本地简单保存
+(void)saveInfo:(id)data name:(NSString *)name;
#pragma mark 本地读取
+(id)readInfo:(NSString *)name;

@end
