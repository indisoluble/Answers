//
//  CDTDocumentRevision+IAWPersistenceDatastoreDocumentProtocol.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 11/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "CDTDocumentRevision+IAWPersistenceDatastoreDocumentProtocol.h"



@implementation CDTDocumentRevision (IAWPersistenceDatastoreDocumentProtocol)

#pragma mark - IAWPersistenceDatastoreDocumentProtocol methods
- (NSDictionary *)dictionary
{
    return [self body];
}

@end
