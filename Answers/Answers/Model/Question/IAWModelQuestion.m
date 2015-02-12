//
//  IAWModelQuestion.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelQuestion.h"



#define IAWMODELQUESTION_NOTDEFINED @"???"



NSString * const kIAWModelQuestionKeyQuestionText = @"question";



@interface IAWModelQuestion ()

@end



@implementation IAWModelQuestion

#pragma mark - Synthesize properties
- (NSString *)questionText
{
    NSString *txt = [[self.document dictionary] objectForKey:kIAWModelQuestionKeyQuestionText];
    
    return (txt ? txt : IAWMODELQUESTION_NOTDEFINED);
}


#pragma mark - Public class methods
+ (NSDictionary *)dictionaryWithQuestionText:(NSString *)text
{
    NSCharacterSet *whiteSpacesAndNewLines = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedTextOrNil = (text ? [text stringByTrimmingCharactersInSet:whiteSpacesAndNewLines] : nil);
    
    NSDictionary *dictionary = nil;
    if (trimmedTextOrNil && ([trimmedTextOrNil length] > 0))
    {
        dictionary = @{kIAWModelQuestionKeyQuestionText: trimmedTextOrNil};
    }
    
    return dictionary;
}

@end
