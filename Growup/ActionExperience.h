//
//  ActionExperience.h
//  Growup
//
//  Created by Jerry on 2017/5/5.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionExperience : NSObject

@property (strong,nonatomic) NSString *actionStatusTypeKey;

@property (strong,nonatomic) NSDate *actionTS;

@property (nonatomic) BOOL isAction;

@property (strong,nonatomic) NSString *contentResourceTypeKey;

@property (strong,nonatomic) NSString *contentResourceUrl;

@property (strong,nonatomic) NSString *logoResourceTypeKey;

@property (strong,nonatomic) NSString *logoResourceUrl;

@property (strong,nonatomic) NSNumber *experienceID;

@property (strong,nonatomic) NSString *experienceName;

@property (strong,nonatomic) NSString *experienceTypeKey;

@property (strong,nonatomic) NSString *experienceUseTypeKey;

@end
