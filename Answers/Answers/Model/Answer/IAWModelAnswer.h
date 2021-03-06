//
//  IAWModelAnswer.h
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

#import <Foundation/Foundation.h>

#import "IAWModelObject.h"



typedef NS_ENUM(NSInteger, IAWModelAnswer_deleteAnswerList_resultType) {
    IAWModelAnswer_deleteAnswerList_resultType_noAnswerDeleted,
    IAWModelAnswer_deleteAnswerList_resultType_someAnswersDeleted,
    IAWModelAnswer_deleteAnswerList_resultType_success
};



@interface IAWModelAnswer : IAWModelObject

@property (strong, nonatomic, readonly) NSString *questionText;
@property (strong, nonatomic, readonly) NSSet *options;

+ (instancetype)createAnswerWithText:(NSString *)text
                             options:(NSSet *)options
                         inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                               error:(NSError **)error;

+ (BOOL)deleteAnswer:(IAWModelAnswer *)answer
         inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
               error:(NSError **)error;

+ (IAWModelAnswer_deleteAnswerList_resultType)deleteAnswerList:(NSArray *)answers
                                                   inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                                                         error:(NSError **)error;

+ (NSSet *)indexableFieldnames;

+ (NSArray *)allAnswersWithText:(NSString *)text
                 inIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager;
+ (NSUInteger)countAnswersWithText:(NSString *)text
                    inIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager;

@end
