//
//  IAWModelObject.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 12/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreDocumentProtocol.h"



@interface IAWModelObject : NSObject

@property (strong, nonatomic, readonly) id<IAWPersistenceDatastoreDocumentProtocol> document;

- (id)initWithDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document;

+ (instancetype)objectWithDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document;

@end
