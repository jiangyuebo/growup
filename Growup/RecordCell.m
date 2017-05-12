//
//  RecordCell.m
//  Growup
//
//  Created by Jerry on 2017/5/10.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "RecordCell.h"

@implementation RecordCell

@synthesize cellType,contentText,contentPics;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
