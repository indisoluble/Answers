//
//  CDTDatastore+IAWPersistenceDatastore.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 09/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "CDTDatastore.h"

#import "IAWPersistenceDocumentProtocol.h"



@interface CDTDatastore (IAWPersistenceDatastore)

- (BOOL)createDocument:(id<IAWPersistenceDocumentProtocol>)document
                 error:(NSError **)error;

- (NSArray *)allDocuments;

@end
