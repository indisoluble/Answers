//
//  CDTDatastore+IAWPersistenceDatastoreProtocol.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <CloudantSync.h>

#import "CDTDatastore+IAWPersistenceDatastoreProtocol.h"



@implementation CDTDatastore (IAWPersistenceDatastoreProtocol)

#pragma mark - IAWPersistenceDatastoreProtocol methods
- (BOOL)createDocument:(id<IAWPersistenceDocumentProtocol>)document
                 error:(NSError **)error
{
    CDTMutableDocumentRevision *revision = [CDTMutableDocumentRevision revision];
    revision.body = [document dictionary];
    
    CDTDocumentRevision *nextRevision = [self createDocumentFromRevision:revision error:error];
    
    BOOL success = (nextRevision != nil);
    if (success)
    {
        NSLog(@"Revision: %@", nextRevision);
    }
    
    return success;
}

@end
