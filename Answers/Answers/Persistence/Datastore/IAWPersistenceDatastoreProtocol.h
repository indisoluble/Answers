//
//  IAWPersistenceDatastoreProtocol.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 14/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreDocumentProtocol.h"



@protocol IAWPersistenceDatastoreProtocol <NSObject>

- (id<IAWPersistenceDatastoreDocumentProtocol>)createDocumentWithDictionary:(NSDictionary *)dictionary
                                                                      error:(NSError **)error;

- (BOOL)deleteDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                 error:(NSError **)error;

- (void)refreshDocuments;

- (NSArray *)allDocuments;

@end
