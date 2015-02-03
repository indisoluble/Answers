//
//  IAWModelQuestion+IAWPersistenceDocumentProtocol.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelQuestion+IAWPersistenceDocumentProtocol.h"



NSString * const kIAWModelQuestionPersistenceDocumentKeyQuestionText = @"question";



@implementation IAWModelQuestion (IAWPersistenceDocumentProtocol)

#pragma mark - IAWPersistenceDocumentProtocol methods
- (NSDictionary *)dictionary
{
    return @{kIAWModelQuestionPersistenceDocumentKeyQuestionText: self.questionText};
}


#pragma mark - Public class methods
+ (instancetype)questionWithDictionary:(NSDictionary *)dictionary
{
    NSString *txt = (dictionary ?
                     dictionary[kIAWModelQuestionPersistenceDocumentKeyQuestionText] :
                     nil);
    
    return [[[self class] alloc] initWithQuestionText:txt];
}

@end
