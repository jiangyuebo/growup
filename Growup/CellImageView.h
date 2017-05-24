//
//  CellImageView.h
//  Growup
//
//  Created by Jerry on 2017/5/24.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellImageView : UIImageView

@property (strong,nonatomic) NSIndexPath *indexPath;

@property (strong,nonatomic) NSString *resourcePath;

@end
