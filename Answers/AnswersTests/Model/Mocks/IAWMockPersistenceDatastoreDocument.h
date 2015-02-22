//
//  IAWMockPersistenceDatastoreDocument.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 22/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreDocumentProtocol.h"



@interface IAWMockPersistenceDatastoreDocument : NSObject <IAWPersistenceDatastoreDocumentProtocol>

@property (strong, nonatomic) NSDictionary *mockDictionary;

@end
