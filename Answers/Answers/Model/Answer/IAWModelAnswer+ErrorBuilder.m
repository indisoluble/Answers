//
//  IAWModelAnswer+ErrorBuilder.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/03/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
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
