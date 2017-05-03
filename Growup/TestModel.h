//
//  TestModel.h
//  Growup
//
//  Created by Jerry on 2017/5/3.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property (strong,nonatomic) NSNumber *evaluationID;

@property (strong,nonatomic) NSString *ageTypeKey;

@property (strong,nonatomic) NSString *evaluationTypeKey;

@property (strong,nonatomic) NSString *evaluationName;

@property (strong,nonatomic) NSString *evaluationDescription;

@property (strong,nonatomic) NSString *logoResourceUrl;

@property (strong,nonatomic) NSString *logoResourceTypeKey;

@property (strong,nonatomic) NSString *contentResourceUrl;

@property (strong,nonatomic) NSString *contentResourceTypeKey;

@property (strong,nonatomic) NSMutableArray *subjectsArray;

@end
