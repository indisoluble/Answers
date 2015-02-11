//
//  CDTDatastore+IAWPersistenceDatastoreLocalStorageProtocol.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <CloudantSync.h>

#import "CDTDatastore+IAWPersistenceDatastoreLocalStorageProtocol.h"

#import "CDTDocumentRevision+IAWPersistenceDocumentProtocol.h"



@implementation CDTDatastore (IAWPersistenceDatastoreLocalStorageProtocol)

#pragma mark - IAWPersistenceDatastoreLocalStorageProtocol methods
- (BOOL)createDocument:(id<IAWPersistenceDocumentProtocol>)document
                 error:(NSError **)error
{
    CDTMutableDocumentRevision *revision = [CDTMutableDocumentRevision revision];
    revision.body = [document dictionary];
    
    CDTDocumentRevision *nextRevision = [self createDocumentFromRevision:revision error:error];
    
    return (nextRevision != nil);
}

- (NSArray *)allDocuments
{
    return [self getAllDocuments];
}

@end
