//
//  RecordCell.h
//  Growup
//
//  Created by Jerry on 2017/5/10.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellImageView.h"

@interface RecordCell : UITableViewCell

@property (strong,nonatomic) NSNumber *cellType;

@property (strong, nonatomic) IBOutlet UITextView *contentText;

@property (strong,nonatomic) NSArray *picUrlArray;

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
