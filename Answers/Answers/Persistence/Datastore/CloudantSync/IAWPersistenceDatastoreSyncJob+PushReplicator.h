//
//  IAWPersistenceDatastoreSyncJob+PushReplicator.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 08/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <CloudantSync.h>

#import "IAWPersistenceDatastoreSyncJob.h"



@interface IAWPersistenceDatastoreSyncJob (PushReplicator)

+ (instancetype)syncJobWithWithManager:(CDTDatastoreManager *)manager
                                source:(CDTDatastore *)datastore
                                target:(NSURL *)remoteDatabaseURL;

@end
