//
//  IAWModelAnswer+ErrorBuilder.h
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
