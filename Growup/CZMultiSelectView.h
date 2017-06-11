//
//  CZMultiSelectView.h
//  Growup
//
//  Created by Jerry on 2017/6/8.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZMultiSelectView : UIView

@property (strong,nonatomic) NSMutableArray *selectedItems;

#pragma mark 初始化选择项数据
- (void)setSelectItemDic:(NSMutableDictionary *) itemsDic;

#pragma mark 设置默认选择项
- (void)setDefaultSelectedItems:(NSArray *) selectedItems;

@end
