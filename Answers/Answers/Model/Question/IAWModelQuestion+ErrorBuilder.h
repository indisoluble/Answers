//
//  IAWModelQuestion+ErrorBuilder.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 14/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelQuestion.h"



typedef enum {
    IAWModelQuestion_errorCodeType_questionTextNotValid = 0
} IAWModelQuestion_errorCodeType;



extern NSString * const kIAWModelQuestionErrorDomain;



@interface IAWModelQuestion (ErrorBuilder)

+ (NSError *)errorQuestionTextNotValid;

@end
