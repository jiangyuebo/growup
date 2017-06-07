//
//  DetailReportCell.m
//  Growup
//
//  Created by Jerry on 2017/6/7.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "DetailReportCell.h"

@implementation DetailReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //初始化健康柱子
    UIImage *jkPillarImage = [[UIImage imageNamed:@"pillar_defaut"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 0, 0,0)];
    [self.pillarImageView1 setImage:jkPillarImage];
    [self.pillarImageView2 setImage:jkPillarImage];
    [self.pillarImageView3 setImage:jkPillarImage];
}

#pragma mark 动画修改柱状图高度
- (void)movePillarView:(UIImageView *) pillarImageView andPillarViewConstant:(NSLayoutConstraint *)pillarConstant ByValue:(int) targetInt{
    
    int cha = 150 - targetInt;
    
    [pillarImageView setNeedsLayout];
    [UIView animateWithDuration:0.8 animations:^{
        pillarImageView.frame = CGRectMake(pillarImageView.frame.origin.x,pillarImageView.frame.origin.y + cha,pillarImageView.frame.size.width,pillarImageView.frame.size.height - cha);
        pillarConstant.constant = pillarConstant.constant - cha;
        [pillarImageView layoutIfNeeded];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
