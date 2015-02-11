//
//  IAWPersistenceDatastoreReplicatorFactoryProtocol.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreReplicatorProtocol.h"



typedef void (^iawPersistenceDatastoreReplicatorCompletionHandlerType)(BOOL success, NSError *error);



@protocol IAWPersistenceDatastoreReplicatorFactoryProtocol <NSObject>

- (id<IAWPersistenceDatastoreReplicatorProtocol>)pushReplicator;
- (id<IAWPersistenceDatastoreReplicatorProtocol>)pullReplicatorWithCompletionHandler:(iawPersistenceDatastoreReplicatorCompletionHandlerType)block;

@end
