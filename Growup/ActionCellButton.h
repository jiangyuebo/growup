//
//  ActionCellButton.h
//  Growup
//
//  Created by Jerry on 2017/5/10.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionCellButton : UIButton

@property (nonatomic) NSUInteger rowIndex;

@property (strong,nonatomic) NSIndexPath *indexPath;

@end
