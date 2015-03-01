//
//  IAWModelAnswer+ErrorBuilder.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/03/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelAnswer+ErrorBuilder.h"



NSString * const kIAWModelAnswerErrorDomain = @"kIAWModelAnswerErrorDomain";



@implementation IAWModelAnswer (ErrorBuilder)

#pragma mark - Public class methods
+ (NSError *)errorQuestionTextNotValid
{
    return [NSError errorWithDomain:kIAWModelAnswerErrorDomain
                               code:IAWModelAnswer_errorCodeType_questionTextNotValid
                           userInfo:nil];
}

+ (NSError *)errorNoOptionsProvided
{
    return [NSError errorWithDomain:kIAWModelAnswerErrorDomain
                               code:IAWModelAnswer_errorCodeType_noOptionsProvided
                           userInfo:nil];
}

+ (NSError *)errorOptionsNotValid
{
    return [NSError errorWithDomain:kIAWModelAnswerErrorDomain
                               code:IAWModelAnswer_errorCodeType_optionsNotValid
                           userInfo:nil];
}

@end
