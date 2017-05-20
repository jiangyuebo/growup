//
//  RecordCell.h
//  Growup
//
//  Created by Jerry on 2017/5/10.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell

@property (strong,nonatomic) NSNumber *cellType;

@property (strong, nonatomic) IBOutlet UITextView *contentText;

@property (strong,nonatomic) NSArray *picUrlArray;

@property (strong, nonatomic) IBOutlet UIImageView *pic1;

@property (strong, nonatomic) IBOutlet UIImageView *pic2;

@property (strong, nonatomic) IBOutlet UIImageView *pic3;


@end
