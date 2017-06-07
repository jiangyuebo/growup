//
//  DetailReportViewController.h
//  Growup
//
//  Created by Jerry on 2017/3/8.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailReportViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *detailReportTable;

@end
