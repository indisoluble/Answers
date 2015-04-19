//
//  IAWModelAnswer.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 28/02/2015.
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

#import "IAWModelAnswer+ErrorBuilder.h"

#import "IAWLog.h"



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

+ (BOOL)deleteAnswer:(IAWModelAnswer *)answer
         inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
               error:(NSError **)error
{
    return [[self class] deleteObject:answer inDatastore:datastore error:error];
}

+ (IAWModelAnswer_deleteAnswerList_resultType)deleteAnswerList:(NSArray *)answers
                                                   inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                                                         error:(NSError **)error
{
    IAWModelAnswer_deleteAnswerList_resultType result = IAWModelAnswer_deleteAnswerList_resultType_noAnswerDeleted;
    
    switch ([[self class] deleteObjectList:answers inDatastore:datastore error:error]) {
        case IAWModelObject_deleteObjectList_resultType_success:
        {
            result = IAWModelAnswer_deleteAnswerList_resultType_success;
            
            break;
        }
        case IAWModelObject_deleteObjectList_resultType_someObjectsDeleted:
        {
            result = IAWModelAnswer_deleteAnswerList_resultType_someAnswersDeleted;
            
            break;
        }
        case IAWModelObject_deleteObjectList_resultType_noObjectDeleted:
        default:
        {
            result = IAWModelAnswer_deleteAnswerList_resultType_noAnswerDeleted;
            
            break;
        }
    }
    
    return result;
}

+ (NSSet *)indexableFieldnames
{
    return [NSSet setWithObject:kIAWModelAnswerKeyQuestionText];
}

+ (NSArray *)allAnswersWithText:(NSString *)text
                 inIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager
{
    NSDictionary *dictionaryOrNil = [IAWModelAnswer dictionaryWithQuestionText:text];
    if (!dictionaryOrNil)
    {
        IAWLogError(@"Text <%@> is not valid", text);
        
        return @[];
    }
    
    id<NSFastEnumeration> allDocumentsOrNil = [IAWModelObject allObjectsWithType:kIAWModelAnswerObjectType
                                                                            data:dictionaryOrNil
                                                                  inIndexManager:indexManager];
    if (!allDocumentsOrNil)
    {
        return @[];
    }
    
    NSMutableArray *allAnswers = [NSMutableArray array];
    for (id<IAWPersistenceDatastoreDocumentProtocol> oneDocument in allDocumentsOrNil)
    {
        [allAnswers addObject:[IAWModelAnswer objectWithDocument:oneDocument]];
    }
    
    return allAnswers;
}

+ (NSUInteger)countAnswersWithText:(NSString *)text
                    inIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager
{
    NSDictionary *dictionaryOrNil = [IAWModelAnswer dictionaryWithQuestionText:text];
    if (!dictionaryOrNil)
    {
        IAWLogError(@"Text <%@> is not valid", text);
        
        return 0;
    }
    
    NSUInteger counter = [IAWModelObject countObjectsWithType:kIAWModelAnswerObjectType
                                                         data:dictionaryOrNil
                                               inIndexManager:indexManager];
    
    return counter;
}


#pragma mark - Private class methods
+ (NSMutableDictionary *)dictionaryWithQuestionText:(NSString *)text
{
    NSString *normalizeText = [IAWModelAnswer normalizeText:text];
    if (!normalizeText)
    {
        return nil;
    }
    
    return [NSMutableDictionary dictionaryWithObject:normalizeText
                                              forKey:kIAWModelAnswerKeyQuestionText];
}

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
    
    NSMutableDictionary *dictionary = [IAWModelAnswer dictionaryWithQuestionText:text];
    if (!dictionary)
    {
        if (error)
        {
            *error = [IAWModelAnswer errorQuestionTextNotValid];
        }
        
        return nil;
    }
    
    NSMutableArray *normalizedOptions = [NSMutableArray arrayWithCapacity:count];
    for (NSString *oneOption in options)
    {
        NSString *oneNormalizedOption = [IAWModelAnswer normalizeText:oneOption];
        if (oneNormalizedOption)
        {
            [normalizedOptions addObject:oneNormalizedOption];
        }
        else
        {
            break;
        }
    }
    if ([normalizedOptions count] != count)
    {
        if (error)
        {
            *error = [IAWModelAnswer errorOptionsNotValid];
        }
        
        return nil;
    }
    
    [dictionary setObject:normalizedOptions forKey:kIAWModelAnswerKeyOptions];
    
    return dictionary;
}

+ (NSString *)normalizeText:(NSString *)text
{
    NSCharacterSet *whiteSpacesAndNewLines = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedTextOrNil = (text ? [text stringByTrimmingCharactersInSet:whiteSpacesAndNewLines] : nil);
    
    return (trimmedTextOrNil && ([trimmedTextOrNil length] > 0) ? trimmedTextOrNil : nil);
}

@end
