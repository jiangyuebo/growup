//
//  CZRadioSelectView.h
//  Growup
//
//  Created by Jerry on 2017/6/3.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZRadioSelectView : UIView

@property (strong,nonatomic) id selectedValue;

#pragma mark 初始化选择项数据
- (void)setSelectItemDic:(NSMutableDictionary *) itemsDic;

#pragma mark 设置默认选择项
- (void)setDefautSelect:(NSMutableDictionary *) selectItemsDic;



@end
