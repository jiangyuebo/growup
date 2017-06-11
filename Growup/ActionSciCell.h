//
//  ActionSciCell.h
//  Growup
//
//  Created by Jerry on 2017/6/8.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionCellButton.h"

@interface ActionSciCell : UITableViewCell

@property (strong, nonatomic) IBOutlet ActionCellButton *btnDetail;

@property (strong, nonatomic) IBOutlet UILabel *cardTitle;

@property (strong, nonatomic) IBOutlet UILabel *cardContent;

@property (strong, nonatomic) IBOutlet ActionCellButton *btnCan;

@property (strong, nonatomic) IBOutlet ActionCellButton *btnCant;

@property (strong, nonatomic) IBOutlet ActionCellButton *btnNotSure;

@end
