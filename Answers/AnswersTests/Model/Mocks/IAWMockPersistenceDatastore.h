//
//  IAWMockPersistenceDatastore.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 14/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
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

@property (assign, nonatomic, readonly) BOOL didRefreshDocuments;
@property (strong, nonatomic) NSError *resultDeleteDocumentError;

@end
