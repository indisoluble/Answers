//
//  CDTDatastore+IAWPersistenceDatastoreLocalStorageProtocol.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <CloudantSync.h>

#import "CDTDatastore+IAWPersistenceDatastoreLocalStorageProtocol.h"

#import "CDTDocumentRevision+IAWPersistenceDatastoreDocumentProtocol.h"



@implementation CDTDatastore (IAWPersistenceDatastoreLocalStorageProtocol)

#pragma mark - IAWPersistenceDatastoreLocalStorageProtocol methods
- (id<IAWPersistenceDatastoreDocumentProtocol>)createDocumentWithDictionary:(NSDictionary *)dictionary
                                                                      error:(NSError **)error
{
    CDTMutableDocumentRevision *revision = [CDTMutableDocumentRevision revision];
    revision.body = dictionary;
    
    CDTDocumentRevision *nextRevision = [self createDocumentFromRevision:revision error:error];
    
    return nextRevision;
}

- (id<IAWPersistenceDatastoreDocumentProtocol>)replaceDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                                                withDictionary:(NSDictionary *)dictionary
                                                         error:(NSError **)error
{
    NSAssert([document isKindOfClass:[CDTDocumentRevision class]], @"Unexpected class");
    
    CDTDocumentRevision *revision = (CDTDocumentRevision *)document;
    
    CDTMutableDocumentRevision *update = [revision mutableCopy];
    update.body = dictionary;
    
    CDTDocumentRevision *nextRevision = [self updateDocumentFromRevision:update error:error];
    
    return nextRevision;
}

- (BOOL)deleteDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                 error:(NSError **)error
{
    NSAssert([document isKindOfClass:[CDTDocumentRevision class]], @"Unexpected class");
    
    CDTDocumentRevision *revision = (CDTDocumentRevision *)document;
    CDTDocumentRevision *nextRevision = [self deleteDocumentFromRevision:revision error:error];
    
    return (nextRevision != nil);
}

@end
