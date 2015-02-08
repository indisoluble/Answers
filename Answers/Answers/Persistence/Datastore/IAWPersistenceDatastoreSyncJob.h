//
//  IAWPersistenceDatastoreSyncJob.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 08/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreSyncJobProtocol.h"
#import "IAWPersistenceDatastoreReplicatorProtocol.h"



@interface IAWPersistenceDatastoreSyncJob : NSObject <IAWPersistenceDatastoreSyncJobProtocol>

- (id)initWithReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)replicator;

+ (instancetype)syncJobWithReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)replicator;

@end
