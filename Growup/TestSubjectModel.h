//
//  TestSubjectModel.h
//  Growup
//
//  Created by Jerry on 2017/5/2.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestSubjectModel : NSObject

@property (strong,nonatomic) NSString *evaluationSubjectDescription;

@property (strong,nonatomic) NSNumber *evaluationSubjectID;

@property (strong,nonatomic) NSNumber *subjectID;

@property (strong,nonatomic) NSString *ageTypeKey;

@property (strong,nonatomic) NSString *subjectTypeKey;

@property (strong,nonatomic) NSString *subjectUseTypeKey;

@property (strong,nonatomic) NSString *subjectOptionTypeKey;

@property (strong,nonatomic) NSString *subjectNum;

@property (strong,nonatomic) NSString *subjectName;

@property (strong,nonatomic) NSString *subjectDescription;

@property (strong,nonatomic) NSString *logoResourceUrl;

@property (strong,nonatomic) NSString *logoResourceTypeKey;

@property (strong,nonatomic) NSString *contentResourceUrl;

@property (strong,nonatomic) NSString *contentResourceTypeKey;

@property (strong,nonatomic) NSString *correctOptionIDs;

@property (strong,nonatomic) NSString *correctAnswerValue;


@end
