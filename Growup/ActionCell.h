//
//  ActionCell.h
//  Growup
//
//  Created by Jerry on 2017/5/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionCellButton.h"

@interface ActionCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *brif;

@property (strong, nonatomic) IBOutlet ActionCellButton *btnCan;

@property (strong, nonatomic) IBOutlet ActionCellButton *btnCant;

@property (strong, nonatomic) IBOutlet ActionCellButton *btnNotSure;


@end
