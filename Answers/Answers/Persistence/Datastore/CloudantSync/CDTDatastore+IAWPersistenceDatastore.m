//
//  CDTDatastore+IAWPersistenceDatastore.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 09/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <CloudantSync.h>

#import "CDTDatastore+IAWPersistenceDatastore.h"

#import "CDTDocumentRevision+IAWPersistenceDocumentProtocol.h"



@implementation CDTDatastore (IAWPersistenceDatastore)

#pragma mark - Public methods
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
