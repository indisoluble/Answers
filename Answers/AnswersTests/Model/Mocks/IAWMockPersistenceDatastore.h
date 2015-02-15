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
@property (strong, nonatomic, readonly) NSDictionary *dictionaryForDocument;
@property (strong, nonatomic) id<IAWPersistenceDatastoreDocumentProtocol> resultCreateDocument;
@property (strong, nonatomic) NSError *resultCreateDocumentError;

@property (assign, nonatomic, readonly) BOOL didDeleteDocument;
@property (assign, nonatomic) BOOL resultDeleteDocument;

@property (assign, nonatomic, readonly) BOOL didRefreshDocuments;
@property (strong, nonatomic) NSError *resultDeleteDocumentError;

@property (assign, nonatomic, readonly) BOOL didGetAllDocuments;
@property (strong, nonatomic) NSArray *resultGetAllDocuments;

@end
