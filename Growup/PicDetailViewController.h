//
//  PicDetailViewController.h
//  Growup
//
//  Created by Jerry on 2017/5/24.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicDetailViewController : UIViewController

@property (strong,nonatomic) NSString *resourcePath;

@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
