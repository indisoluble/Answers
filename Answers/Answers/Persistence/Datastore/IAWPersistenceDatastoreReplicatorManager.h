//
//  IAWPersistenceDatastoreReplicatorManager.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreReplicatorProtocol.h"



@interface IAWPersistenceDatastoreReplicatorManager : NSObject

- (void)queueReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)replicator;

+ (instancetype)replicatorManager;

@end
