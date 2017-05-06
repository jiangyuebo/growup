//
//  ExperienceModel.h
//  Growup
//
//  Created by Jerry on 2017/5/6.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExperienceModel : NSObject

@property (strong,nonatomic) NSString *ageTypeKey;

@property (strong,nonatomic) NSString *contentResourceTypeKey;

@property (strong,nonatomic) NSString *contentResourceUrl;

@property (strong,nonatomic) NSString *experienceBrief;

@property (strong,nonatomic) NSString *experienceDescription;

@property (strong,nonatomic) NSNumber *experienceID;

@property (strong,nonatomic) NSString *experienceName;

@property (strong,nonatomic) NSString *experienceTypeKey;

@property (strong,nonatomic) NSString *experienceUseTypeKey;

@property (strong,nonatomic) NSString *logoResourceTypeKey;

@property (strong,nonatomic) NSString *logoResourceUrl;

@end
