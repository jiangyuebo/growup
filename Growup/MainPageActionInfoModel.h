//
//  MainPageActionInfoModel.h
//  Growup
//
//  Created by Jerry on 2017/5/5.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainPageActionInfoModel : NSObject

@property (strong,nonatomic) NSNumber *actionNumber;

@property (strong,nonatomic) NSNumber *actionFinishNumber;

@property (strong,nonatomic) NSDate *actionTS;

@property (strong,nonatomic) NSNumber *childID;

@property (nonatomic) BOOL isFinish;

@property (strong,nonatomic) NSNumber *userActionID;

//userActionSuject array
@property (strong,nonatomic) NSMutableArray *userActionSubjects;

//userActionExperiences array
@property (strong,nonatomic) NSMutableArray *userActionExperiences;

//userActionTasks
@property (strong,nonatomic) NSMutableArray *userActionTasks;

@end
