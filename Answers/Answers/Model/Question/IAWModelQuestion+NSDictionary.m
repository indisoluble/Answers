//
//  IAWModelQuestion+NSDictionary.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 11/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelQuestion+NSDictionary.h"



NSString * const kIAWModelQuestionNSDictionaryKeyQuestionText = @"question";



@implementation IAWModelQuestion (NSDictionary)

#pragma mark - Public methods
- (NSDictionary *)dictionary
{
    return @{kIAWModelQuestionNSDictionaryKeyQuestionText: self.questionText};
}


#pragma mark - Public class methods
+ (instancetype)questionWithDictionary:(NSDictionary *)dictionary
{
    NSString *txt = (dictionary ?
                     dictionary[kIAWModelQuestionNSDictionaryKeyQuestionText] :
                     nil);
    
    return [[[self class] alloc] initWithQuestionText:txt];
}

@end
