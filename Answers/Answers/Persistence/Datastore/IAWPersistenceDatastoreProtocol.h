//
//  IAWPersistenceDatastoreProtocol.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDocumentProtocol.h"



@protocol IAWPersistenceDatastoreProtocol <NSObject>

- (BOOL)createDocument:(id<IAWPersistenceDocumentProtocol>)document
                 error:(NSError **)error;

- (NSArray *)allDocuments;

@end
