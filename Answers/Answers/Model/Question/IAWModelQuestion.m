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
NSString * const kIAWModelQuestionKeyQuestionText = @"question_text";
NSString * const kIAWModelQuestionKeyQuestionOptions = @"question_options";



@interface IAWModelQuestion ()

@end



@implementation IAWModelQuestion

#pragma mark - Synthesize properties
- (NSString *)questionText
{
    NSDictionary *dic = [self.document dictionary];
    NSString *txt = dic[kIAWModelQuestionKeyQuestionText];
    
    return (txt ? txt : NSLocalizedString(@"Question text not defined", @"Question text not defined"));
}

- (NSSet *)options
{
    NSDictionary *dic = [self.document dictionary];
    NSArray *array = dic[kIAWModelQuestionKeyQuestionOptions];
    
    return (array ? [NSSet setWithArray:array] : [NSSet set]);
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

+ (instancetype)replaceQuestion:(IAWModelQuestion *)question
                 byAddingOption:(NSString *)option
                    inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                          error:(NSError **)error
{
    NSDictionary *dictionary = [IAWModelQuestion dictionaryBasedOnQuestion:question
                                                                withOption:option];
    if (!dictionary)
    {
        if (error)
        {
            *error = [IAWModelQuestion errorOptionNotValid];
        }
        
        return nil;
    }
    
    return [[self class] replaceObject:question
                             usingData:dictionary
                           inDatastore:datastore
                                 error:error];
}

+ (NSArray *)allQuestionsInIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager
{
    id<NSFastEnumeration> allDocumentsOrNil = [IAWModelObject allObjectsWithType:kIAWModelQuestionObjectType
                                                                  inIndexManager:indexManager];
    if (!allDocumentsOrNil)
    {
        return @[];
    }
    
    NSMutableArray *allQuestions = [NSMutableArray array];
    for (id<IAWPersistenceDatastoreDocumentProtocol> oneDocument in allDocumentsOrNil)
    {
        [allQuestions addObject:[IAWModelQuestion objectWithDocument:oneDocument]];
    }
    
    return allQuestions;
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

+ (NSDictionary *)dictionaryBasedOnQuestion:(IAWModelQuestion *)question
                                 withOption:(NSString *)option
{
    NSCharacterSet *whiteSpacesAndNewLines = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedOptionOrNil = (option ? [option stringByTrimmingCharactersInSet:whiteSpacesAndNewLines] : nil);
    
    NSDictionary *dictionary = nil;
    if (question && trimmedOptionOrNil && ([trimmedOptionOrNil length] > 0))
    {
        NSArray *allOptions = [[question.options setByAddingObject:option] allObjects];
        
        dictionary = @{kIAWModelQuestionKeyQuestionText: question.questionText,
                       kIAWModelQuestionKeyQuestionOptions:allOptions};
    }
    
    return dictionary;
}

@end
