//
//  CZChangeUserNickNameViewController.h
//  Growup
//
//  Created by Jerry on 2017/6/2.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZTextField.h"

//IdentifyNameChangeUserNickNameViewController
@interface CZChangeUserNickNameViewController : UIViewController

@property (strong, nonatomic) IBOutlet CZTextField *userNicknameText;

@property (strong,nonatomic) NSMutableDictionary *passDataDic;


@end
