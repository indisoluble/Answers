//
//  IAWModelQuestion.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWModelObject.h"



@interface IAWModelQuestion : IAWModelObject

@property (strong, nonatomic, readonly) NSString *questionText;
@property (strong, nonatomic, readonly) NSSet *options;

+ (instancetype)createQuestionWithText:(NSString *)text
                           inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                                 error:(NSError **)error;

+ (instancetype)replaceQuestion:(IAWModelQuestion *)question
                 byAddingOption:(NSString *)option
                    inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                          error:(NSError **)error;

+ (NSArray *)allQuestionsInIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager;

@end
