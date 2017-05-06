//
//  ActionSubject.h
//  Growup
//
//  Created by Jerry on 2017/5/5.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionSubject : NSObject

@property (strong,nonatomic) NSString *actionStatusTypeKey;

@property (strong,nonatomic) NSDate *actionTS;

@property (nonatomic) BOOL isAction;

@property (strong,nonatomic) NSString *contentResourceTypeKey;

@property (strong,nonatomic) NSString *contentResourceUrl;

@property (strong,nonatomic) NSString *logoResourceTypeKey;

@property (strong,nonatomic) NSString *logoResourceUrl;

@property (strong,nonatomic) NSString *subjectDescription;

@property (strong,nonatomic) NSNumber *subjectID;

@property (strong,nonatomic) NSString *subjectName;

@property (strong,nonatomic) NSString *subjectNum;

@property (strong,nonatomic) NSString *subjectOptionTypeKey;

@property (strong,nonatomic) NSString *subjectTypeKey;

@property (strong,nonatomic) NSString *subjectUseTypeKey;

@end
