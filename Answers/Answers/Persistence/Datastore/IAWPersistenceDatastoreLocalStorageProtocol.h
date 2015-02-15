//
//  IAWPersistenceDatastoreLocalStorageProtocol.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreDocumentProtocol.h"



@protocol IAWPersistenceDatastoreLocalStorageProtocol <NSObject>

- (id<IAWPersistenceDatastoreDocumentProtocol>)createDocumentWithDictionary:(NSDictionary *)dictionary
                                                                      error:(NSError **)error;

- (BOOL)deleteDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                 error:(NSError **)error;

@end
