//
//  IAWMockPersistenceDatastore.h
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

#import "IAWPersistenceDatastoreProtocol.h"



@interface IAWMockPersistenceDatastore : NSObject <IAWPersistenceDatastoreProtocol>

@property (assign, nonatomic, readonly) BOOL didCreateDocument;
@property (strong, nonatomic, readonly) NSDictionary *dictionaryForCreatedDocument;
@property (strong, nonatomic) id<IAWPersistenceDatastoreDocumentProtocol> resultCreateDocument;
@property (strong, nonatomic) NSError *resultCreateDocumentError;

@property (assign, nonatomic, readonly) BOOL didReplaceDocument;
@property (strong, nonatomic, readonly) NSDictionary *dictionaryForReplacedDocument;
@property (strong, nonatomic) id<IAWPersistenceDatastoreDocumentProtocol> resultReplaceDocument;
@property (strong, nonatomic) NSError *resultReplaceDocumentError;

@property (assign, nonatomic, readonly) BOOL didDeleteDocument;
@property (assign, nonatomic) BOOL resultDeleteDocument;
@property (strong, nonatomic) NSError *resultDeleteDocumentError;

@property (assign, nonatomic, readonly) BOOL didDeleteDocumentList;
@property (assign, nonatomic) IAWPersistenceDatastore_deleteDocumentList_resultType resultDeleteDocumentList;
@property (strong, nonatomic) NSError *resultDeleteDocumentListError;

@property (assign, nonatomic, readonly) BOOL didRefreshDocuments;

@end
