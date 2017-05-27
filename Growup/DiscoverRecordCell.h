//
//  DiscoverRecordCell.h
//  Growup
//
//  Created by Jerry on 2017/5/13.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellImageView.h"

@interface DiscoverRecordCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatar;

@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (strong, nonatomic) IBOutlet UILabel *content;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *upIcon;

@property (strong, nonatomic) IBOutlet CellImageView *pic1;

@property (strong, nonatomic) IBOutlet CellImageView *pic2;

@property (strong, nonatomic) IBOutlet CellImageView *pic3;

@property (strong, nonatomic) IBOutlet CellImageView *pic4;

@property (strong, nonatomic) IBOutlet CellImageView *pic5;

@property (strong, nonatomic) IBOutlet CellImageView *pic6;

@property (strong, nonatomic) IBOutlet CellImageView *pic7;

@property (strong, nonatomic) IBOutlet CellImageView *pic8;

@property (strong, nonatomic) IBOutlet CellImageView *pic9;

@end
