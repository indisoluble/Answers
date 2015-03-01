//
//  IAWModelAnswer.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 28/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelAnswer.h"

#import "IAWModelAnswer+ErrorBuilder.h"



NSString * const kIAWModelAnswerObjectType = @"answer";
NSString * const kIAWModelAnswerKeyQuestionText = @"answer_text";
NSString * const kIAWModelAnswerKeyOptions = @"answer_options";



@interface IAWModelAnswer ()

@end



@implementation IAWModelAnswer

#pragma mark - Synthesize properties
- (NSString *)questionText
{
    NSDictionary *dic = [self.document dictionary];
    NSString *txt = dic[kIAWModelAnswerKeyQuestionText];
    
    return (txt ? txt : NSLocalizedString(@"Question text not defined", @"Question text not defined"));
}

- (NSSet *)options
{
    NSDictionary *dic = [self.document dictionary];
    NSArray *array = dic[kIAWModelAnswerKeyOptions];
    
    return (array ? [NSSet setWithArray:array] : [NSSet set]);
}


#pragma mark - Public class methods
+ (instancetype)createAnswerWithText:(NSString *)text
                             options:(NSSet *)options
                         inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                               error:(NSError **)error
{
    NSDictionary *dictionary = [IAWModelAnswer dictionaryWithQuestionText:text
                                                                  options:options
                                                                    error:error];
    if (!dictionary)
    {
        return nil;
    }
    
    return [[self class] createObjectWithType:kIAWModelAnswerObjectType
                                         data:dictionary
                                  inDatastore:datastore
                                        error:error];
}


#pragma mark - Private class methods
+ (NSDictionary *)dictionaryWithQuestionText:(NSString *)text
                                     options:(NSSet *)options
                                       error:(NSError **)error
{
    NSUInteger count = [options count];
    if (count == 0)
    {
        if (error)
        {
            *error = [IAWModelAnswer errorNoOptionsProvided];
        }
        
        return nil;
    }
    
    NSCharacterSet *whiteSpacesAndNewLines = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedText= (text ? [text stringByTrimmingCharactersInSet:whiteSpacesAndNewLines] : nil);
    if (!trimmedText || ([trimmedText length] == 0))
    {
        if (error)
        {
            *error = [IAWModelAnswer errorQuestionTextNotValid];
        }
        
        return nil;
    }
    
    NSMutableArray *trimmedOptions = [NSMutableArray arrayWithCapacity:count];
    for (NSString *oneOption in options)
    {
        NSString *oneTrimmedOption = [oneOption stringByTrimmingCharactersInSet:whiteSpacesAndNewLines];
        if ([oneTrimmedOption length] > 0)
        {
            [trimmedOptions addObject:oneTrimmedOption];
        }
        else
        {
            break;
        }
    }
    if ([trimmedOptions count] != count)
    {
        if (error)
        {
            *error = [IAWModelAnswer errorOptionsNotValid];
        }
        
        return nil;
    }
    
    NSDictionary *dictionary = @{kIAWModelAnswerKeyQuestionText: trimmedText,
                                 kIAWModelAnswerKeyOptions: trimmedOptions};
    
    return dictionary;
}

@end
