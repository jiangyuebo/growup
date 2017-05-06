//
//  ActionTask.h
//  Growup
//
//  Created by Jerry on 2017/5/5.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionTask : NSObject

@property (strong,nonatomic) NSNumber *taskID;

@property (strong,nonatomic) NSString *taskName;

@property (strong,nonatomic) NSString *actionStatusTypeKey;

@property (strong,nonatomic) NSDate *actionTS;

@property (nonatomic) BOOL isAction;

@property (strong,nonatomic) NSString *contentResourceTypeKey;

@property (strong,nonatomic) NSString *contentResourceUrl;

@property (strong,nonatomic) NSString *logoResourceTypeKey;

@property (strong,nonatomic) NSString *logoResourceUrl;

@property (strong,nonatomic) NSString *taskActionTypeKey;

@property (strong,nonatomic) NSString *taskDescription;

@property (strong,nonatomic) NSString *taskTypeKey;

@property (strong,nonatomic) NSString *taskUseTypeKey;

@property (strong,nonatomic) NSString *taskActionDescription;

@end
