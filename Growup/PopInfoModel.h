//
//  PopInfoModel.h
//  Growup
//
//  Created by Jerry on 2017/4/29.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopInfoModel : NSObject

@property (strong,nonatomic) NSString *ageTypeKey;

@property (strong,nonatomic) NSString *childDynamicTypeKey;

@property (strong,nonatomic) NSString *infoName;

@property (strong,nonatomic) NSString *infoDescription;

@property (strong,nonatomic) NSString *logoResourceUrl;

@property (strong,nonatomic) NSString *logoResourceTypeKey;

@property (strong,nonatomic) NSString *contentResourceUrl;

@property (strong,nonatomic) NSString *contentResourceTypeKey;

@property (strong,nonatomic) NSNumber *score;

@property (strong,nonatomic) NSNumber *weight;

@property (strong,nonatomic) NSNumber *childDynamicID;

@property (strong,nonatomic) NSNumber *correctAnswerValue;

@end
