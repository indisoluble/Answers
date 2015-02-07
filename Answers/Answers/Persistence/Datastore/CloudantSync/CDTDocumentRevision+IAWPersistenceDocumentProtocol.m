//
//  CDTDocumentRevision+IAWPersistenceDocumentProtocol.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 03/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "CDTDocumentRevision+IAWPersistenceDocumentProtocol.h"



@implementation CDTDocumentRevision (IAWPersistenceDocumentProtocol)

#pragma mark - IAWPersistenceDocumentProtocol methods
- (NSDictionary *)dictionary
{
    return [self body];
}

@end
