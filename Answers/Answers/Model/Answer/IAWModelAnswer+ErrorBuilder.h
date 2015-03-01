//
//  IAWModelAnswer+ErrorBuilder.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/03/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelAnswer.h"



typedef enum {
    IAWModelAnswer_errorCodeType_questionTextNotValid = 0,
    IAWModelAnswer_errorCodeType_noOptionsProvided,
    IAWModelAnswer_errorCodeType_optionsNotValid
} IAWModelAnswer_errorCodeType;



extern NSString * const kIAWModelAnswerErrorDomain;



@interface IAWModelAnswer (ErrorBuilder)

+ (NSError *)errorQuestionTextNotValid;
+ (NSError *)errorNoOptionsProvided;
+ (NSError *)errorOptionsNotValid;

@end
