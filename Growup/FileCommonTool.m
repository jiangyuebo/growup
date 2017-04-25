//
//  FileCommonTool.m
//  Growup
//
//  Created by Jerry on 2017/3/1.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "FileCommonTool.h"

@implementation FileCommonTool

#pragma mark - userDefault文件操作
#pragma mark 保存
+(void)saveInfo:(id)data name:(NSString *)name{
    
    if(data == nil || name == nil){
        NSLog(@"保存的数据或键值为空，请注意");
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:name];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 读取
+(id)readInfo:(NSString *)name{
    if(name == nil){
        return nil;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}

@end
