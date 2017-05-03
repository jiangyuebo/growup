//
//  AbilityModel.h
//  Growup
//
//  Created by Jerry on 2017/4/29.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbilityModel : NSObject

@property (strong,nonatomic) NSString *abilityStatusTypeKey;

@property (strong,nonatomic) NSNumber *indexArtScore;

@property (strong,nonatomic) NSString *indexArtStatusTypeKey;

@property (strong,nonatomic) NSNumber *indexHealthScore;

@property (strong,nonatomic) NSString *indexHealthStatusTypeKey;

@property (strong,nonatomic) NSNumber *indexLanguageScore;

@property (strong,nonatomic) NSString *indexLanguageStatusTypeKey;

@property (strong,nonatomic) NSNumber *indexScienceScore;

@property (strong,nonatomic) NSString *indexScienceStatusTypeKey;

@property (strong,nonatomic) NSNumber *indexSociologyScore;

@property (strong,nonatomic) NSString *indexSociologyStatusTypeKey;

@property (nonatomic) BOOL isAbilityExpired;

@property (strong,nonatomic) NSNumber *userAbilityID;

@end
