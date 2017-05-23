//
//  ActionExpCell.h
//  Growup
//
//  Created by Jerry on 2017/5/21.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionCellButton.h"

@interface ActionExpCell : UITableViewCell

//卡片icon图片
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

//卡片标题
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

//卡片背景图片
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;

//卡片控制按钮
@property (strong, nonatomic) IBOutlet ActionCellButton *actionButton;

//卡片描述文字
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

//补充描述文字
@property (strong, nonatomic) IBOutlet UILabel *subContentLabel;

//完成
@property (strong, nonatomic) IBOutlet ActionCellButton *btnFinish;

//放弃
@property (strong, nonatomic) IBOutlet ActionCellButton *btnAbandon;

//以后再说
@property (strong, nonatomic) IBOutlet ActionCellButton *btnOtherTime;

@end
