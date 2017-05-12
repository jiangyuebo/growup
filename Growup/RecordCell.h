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

@property (strong, nonatomic) IBOutlet UICollectionView *contentPics;

@end
