//
//  IAWModelQuestion.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelQuestion.h"

#import "IAWModelQuestion+ErrorBuilder.h"



NSString * const kIAWModelQuestionObjectType = @"question";
NSString * const kIAWModelQuestionKeyQuestionText = @"question";



@interface IAWModelQuestion ()

@end



@implementation IAWModelQuestion

#pragma mark - Synthesize properties
- (NSString *)questionText
{
    NSString *txt = [[self.document dictionary] objectForKey:kIAWModelQuestionKeyQuestionText];
    
    return (txt ? txt : NSLocalizedString(@"Question text not defined", @"Question text not defined"));
}


#pragma mark - Public class methods
+ (instancetype)createQuestionWithText:(NSString *)text
                           inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                                 error:(NSError **)error
{
    NSDictionary *dictionary = [IAWModelQuestion dictionaryWithQuestionText:text];
    if (!dictionary)
    {
        if (error)
        {
            *error = [IAWModelQuestion errorQuestionTextNotValid];
        }
        
        return nil;
    }
    
    return [[self class] createObjectWithType:kIAWModelQuestionObjectType
                                         data:dictionary
                                  inDatastore:datastore
                                        error:error];
}


#pragma mark - Private class methods
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
