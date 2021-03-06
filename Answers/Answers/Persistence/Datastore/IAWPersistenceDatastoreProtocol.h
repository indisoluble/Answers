//
//  IAWPersistenceDatastoreProtocol.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 14/02/2015.
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

#import "IAWPersistenceDatastoreDocumentProtocol.h"



typedef NS_ENUM(NSInteger, IAWPersistenceDatastore_deleteDocumentList_resultType) {
    IAWPersistenceDatastore_deleteDocumentList_resultType_noDocumentDeleted,
    IAWPersistenceDatastore_deleteDocumentList_resultType_someDocumentsDeleted,
    IAWPersistenceDatastore_deleteDocumentList_resultType_success
};



@protocol IAWPersistenceDatastoreProtocol <NSObject>

- (id<IAWPersistenceDatastoreDocumentProtocol>)createDocumentWithDictionary:(NSDictionary *)dictionary
                                                                      error:(NSError **)error;

- (id<IAWPersistenceDatastoreDocumentProtocol>)replaceDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                                                withDictionary:(NSDictionary *)dictionary
                                                         error:(NSError **)error;

- (BOOL)deleteDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                 error:(NSError **)error;

- (IAWPersistenceDatastore_deleteDocumentList_resultType)deleteDocumentList:(NSArray *)documents
                                                                      error:(NSError **)error;

- (void)refreshDocuments;

@end
