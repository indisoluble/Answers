//
//  IAWModelQuestion+ErrorBuilder.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 14/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelQuestion+ErrorBuilder.h"



NSString * const kIAWModelQuestionErrorDomain = @"kIAWModelQuestionErrorDomain";



@implementation IAWModelQuestion (ErrorBuilder)

#pragma mark - Public class methods
+ (NSError *)errorQuestionTextNotValid
{
    return [NSError errorWithDomain:kIAWModelQuestionErrorDomain
                               code:IAWModelQuestion_errorCodeType_questionTextNotValid
                           userInfo:nil];
}

@end
