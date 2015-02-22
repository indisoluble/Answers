//
//  IAWMockPersistenceDatastoreDocument.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 22/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWMockPersistenceDatastoreDocument.h"



@interface IAWMockPersistenceDatastoreDocument ()

@end



@implementation IAWMockPersistenceDatastoreDocument

#pragma mark - IAWPersistenceDatastoreDocumentProtocol methods
- (NSDictionary *)dictionary
{
    return self.mockDictionary;
}

@end
