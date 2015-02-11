//
//  IAWModelQuestion.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelQuestion.h"



@interface IAWModelQuestion ()

@end



@implementation IAWModelQuestion

#pragma mark - Init object
- (id)init
{
    return [self initWithQuestionText:nil];
}

- (id)initWithQuestionText:(NSString *)text
{
    self = [super init];
    if (self)
    {
        NSCharacterSet *whiteSpacesAndNewLines = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmedTextOrNil = (text ?
                                      [text stringByTrimmingCharactersInSet:whiteSpacesAndNewLines] :
                                      nil);
        if (!trimmedTextOrNil || ([trimmedTextOrNil length] == 0))
        {
            self = nil;
        }
        else
        {
            _questionText = trimmedTextOrNil;
        }
    }
    
    return self;
}

@end
