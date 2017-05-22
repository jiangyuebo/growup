//
//  ActionExpCell.m
//  Growup
//
//  Created by Jerry on 2017/5/21.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "ActionExpCell.h"

@implementation ActionExpCell

@synthesize iconImageView,titleLabel,bgImageView,actionButton,contentLabel,subContentLabel,btnFinish,btnAbandon,btnOtherTime;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
