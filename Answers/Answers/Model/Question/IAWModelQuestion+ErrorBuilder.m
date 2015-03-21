//
//  IAWModelQuestion+ErrorBuilder.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 14/02/2015.
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

+ (BOOL)isErrorQuestionTextInUse:(NSError *)error
{
    return (error &&
            [error.domain isEqualToString:kIAWModelQuestionErrorDomain] &&
            (error.code == IAWModelQuestion_errorCodeType_questionTextInUse));
}

+ (NSError *)errorQuestionTextInUse
{
    return [NSError errorWithDomain:kIAWModelQuestionErrorDomain
                               code:IAWModelQuestion_errorCodeType_questionTextInUse
                           userInfo:nil];
}

+ (NSError *)errorOptionNotValid
{
    return [NSError errorWithDomain:kIAWModelQuestionErrorDomain
                               code:IAWModelQuestion_errorCodeType_optionNotValid
                           userInfo:nil];
}

@end
