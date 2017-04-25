//
//  CZTextField.m
//  Growup
//
//  Created by Jerry on 2017/4/22.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZTextField.h"

@implementation CZTextField

//设置占位符位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+15, bounds.origin.y, bounds.size.width, bounds.size.height);
    return inset;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
