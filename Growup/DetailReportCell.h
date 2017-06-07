//
//  DetailReportCell.h
//  Growup
//
//  Created by Jerry on 2017/6/7.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailReportCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

//柱子系列
//1
@property (strong, nonatomic) IBOutlet UIImageView *pillarImageView1;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pillarHeight1;

@property (strong, nonatomic) IBOutlet UILabel *pillarLabel1;

//2
@property (strong, nonatomic) IBOutlet UIImageView *pillarImageView2;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pillarHeight2;

@property (strong, nonatomic) IBOutlet UILabel *pillarLabel2;

//3
@property (strong, nonatomic) IBOutlet UIImageView *pillarImageView3;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pillarHeight3;

@property (strong, nonatomic) IBOutlet UILabel *pillarLabel3;

//建议
@property (strong, nonatomic) IBOutlet UILabel *suggestLabel;


- (void)movePillarView:(UIImageView *) pillarImageView andPillarViewConstant:(NSLayoutConstraint *)pillarConstant ByValue:(int) targetInt;

@end
